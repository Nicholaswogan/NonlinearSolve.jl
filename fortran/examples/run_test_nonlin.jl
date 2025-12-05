#!/usr/bin/env julia
using Pkg

const ROOT = normpath(@__DIR__, "..", "..")
Pkg.activate(ROOT)
Pkg.instantiate()

using LinearAlgebra
using Printf
using NonlinearSolve
using LineSearch: BackTracking
include(joinpath(@__DIR__, "test_nonlin.jl"))

const REPS = 100
const ATOL = 1e-10
const RTOL = 1e-10

const SOLVERS = [
    ("TR", () -> TrustRegion(radius_update_scheme = RadiusUpdateSchemes.NLsolve)),
    ("NR", () -> NewtonRaphson()),
    ("NR_BT", () -> NewtonRaphson(linesearch = BackTracking()))
]

struct RunStats
    prob::Int
    n::Int
    solver::String
    retcode::Any
    nf::Any
    njacs::Any
    nsolve::Any
    bt_steps::Any
    avg_time::Float64
    fnorm::Float64
    u::Vector{Float64}
end

get_or(x, name) = Base.hasproperty(x, name) ? getproperty(x, name) : missing

function run_julia_problem(prob::Int, solver_name::String, alg_factory)
    nval = p00_n(prob)
    n = abs(nval)
    u0 = p00_start(prob, n)

    f! = (du, u, p) -> p00_fx(prob, n, u, du)
    jac! = (J, u, p) -> p00_jac(prob, n, u, J)
    nf = NonlinearFunction(f!; jac = jac!)
    nlprob = NonlinearProblem(nf, u0, nothing)

    alg = alg_factory()
    t_start = time()
    sol = nothing
    for _ in 1:REPS
        sol = solve(nlprob, alg; abstol = ATOL, reltol = RTOL)
    end
    t_end = time()
    avg_time = (t_end - t_start) / REPS

    u = sol.u
    fvec = p00_fx(prob, n, u)
    fnorm = norm(fvec)

    stats = sol.stats
    RunStats(prob, n, solver_name, sol.retcode, get_or(stats, :nf), get_or(stats, :njacs),
             get_or(stats, :nsolve), get_or(stats, :nbacktracks), avg_time, fnorm, collect(u))
end

function run_all_julia()
    results = RunStats[]
    for prob in 1:p00_problem_num()
        for (name, factory) in SOLVERS
            push!(results, run_julia_problem(prob, name, factory))
        end
    end
    results
end

struct FortranStats
    prob::Int
    n::Int
    solver::String
    ret::Int
    nf::Int
    njac::Int
    nsolve::Int
    bt::Int
    avg_time::Float64
    fnorm::Float64
    title::String
end

function build_and_run_fortran()
    exe = joinpath(@__DIR__, "run_test_nonlin_exec")
    srcs = [
        joinpath(ROOT, "fortran", "src", "nonlinearsolve.f90"),
        joinpath(ROOT, "fortran", "examples", "test_nonlin.f90"),
        joinpath(ROOT, "fortran", "examples", "run_test_nonlin.f90"),
    ]
    run(`gfortran -O3 $(srcs) -llapack -o $exe`)
    read(`$exe`, String)
end

function parse_fortran_output(text::String)
    records = Dict{Tuple{Int,String},FortranStats}()
    for line in eachline(IOBuffer(text))
        s = strip(line)
        if isempty(s) || startswith(s, "prob") || startswith(s, "---")
            continue
        end
        fields = split(s, '|')
        if length(fields) < 11
            continue
        end
        prob = parse(Int, strip(fields[1]))
        n = parse(Int, strip(fields[2]))
        solver = strip(fields[3])
        ret = parse(Int, strip(fields[4]))
        nf = parse(Int, strip(fields[5]))
        njac = parse(Int, strip(fields[6]))
        nsolve = parse(Int, strip(fields[7]))
        bt = parse(Int, strip(fields[8]))
        avg_time = parse(Float64, strip(fields[9]))
        fnorm = parse(Float64, strip(fields[10]))
        title = strip(fields[11])
        records[(prob, solver)] = FortranStats(prob, n, solver, ret, nf, njac, nsolve, bt, avg_time, fnorm, title)
    end
    records
end

function main()
    println("Running Julia solvers...")
    julia_stats = run_all_julia()

    fortran_records = Dict{Tuple{Int,String},FortranStats}()
    try
        println("Building and running Fortran reference...")
        out = build_and_run_fortran()
        fortran_records = parse_fortran_output(out)
    catch err
        @warn "Could not run Fortran comparison; showing Julia results only" error=err
    end

    header = ["prob","n","solver","ret_jl","ret_ft","nf_jl","nf_ft","nj_jl","nj_ft","nsolve_jl","nsolve_ft","fnorm_jl","fnorm_ft","title"]
    fmt_row(prob,n,solver,rjl,rft,nf_jl,nf_ft,nj_jl,nj_ft,ns_jl,ns_ft,fn_jl,fn_ft,title) =
        @sprintf("%4s | %3s | %-6s | %6s | %6s | %6s | %6s | %6s | %6s | %9s | %9s | %11s | %11s | %s",
                 prob,n,solver,rjl,rft,nf_jl,nf_ft,nj_jl,nj_ft,ns_jl,ns_ft,fn_jl,fn_ft,title)
    println(fmt_row(header...))
    println(repeat("-", 150))
    for js in julia_stats
        if true
            ft = get(fortran_records, (js.prob, js.solver), nothing)
            nf_ft = ft === nothing ? "n/a" : string(ft.nf)
            r_ft = ft === nothing ? "n/a" : begin
                ft.ret == 0 ? "Success" :
                ft.ret == 1 ? "MaxIters" :
                ft.ret == 2 ? "LinearSolveFailure" :
                ft.ret == 3 ? "BacktrackingFailure" :
                ft.ret == 4 ? "Stalled" :
                ft.ret == 5 ? "Unstable" :
                string(ft.ret)
            end
            nj_ft = ft === nothing ? "n/a" : string(ft.njac)
            ns_ft = ft === nothing ? "n/a" : string(ft.nsolve)
            fn_ft = ft === nothing ? "n/a" : @sprintf("%.3e", ft.fnorm)
            title = ft === nothing ? p00_title(js.prob) : ft.title
            println(fmt_row(
                string(js.prob),
                string(js.n),
                js.solver,
                string(js.retcode),
                r_ft,
                string(js.nf),
                nf_ft,
                string(js.njacs),
                nj_ft,
                string(js.nsolve),
                ns_ft,
                @sprintf("%.3e", js.fnorm),
                fn_ft,
                title
            ))
        end
    end
end

main()
