#!/usr/bin/env julia
using Pkg

const ROOT = normpath(@__DIR__, "..", "..")
Pkg.activate(ROOT)
Pkg.develop(PackageSpec(path = normpath(ROOT, "lib", "NonlinearSolveFirstOrder")))
Pkg.instantiate()

using LinearAlgebra
using NonlinearProblemLibrary
using NonlinearSolveFirstOrder
using LineSearch: BackTracking
using Printf
using SciMLBase

const REPS = 100

function get_or(x, name, default)
    return Base.hasproperty(x, name) ? getproperty(x, name) : default
end

function run_solver(prob, alg; bt_steps_default = 0)
    sol = solve(prob, alg; abstol = 1e-10, reltol = 1e-10)
    t_accum = 0.0
    for _ in 1:REPS
        t_accum += @elapsed solve(prob, alg; abstol = 1e-10, reltol = 1e-10)
    end
    avg_t = t_accum / REPS
    stats = sol.stats
    return (
        ret = sol.retcode == SciMLBase.ReturnCode.Success ? 0 : 1,
        nf = get_or(stats, :nf, 0),
        njac = get_or(stats, :njacs, 0),
        nsolve = get_or(stats, :nsolve, 0),
        bt = get_or(stats, :nbacktracks, bt_steps_default),
        avg_t = avg_t,
        fnorm = norm(prob.f(sol.u, prob.p))
    )
end

function main()
    alg_tr = TrustRegion(radius_update_scheme = RadiusUpdateSchemes.NLsolve)
    alg_nr = NewtonRaphson()
    alg_nr_bt = NewtonRaphson(linesearch = BackTracking())

    @printf(" %4s | %4s | %8s | %4s | %6s | %6s | %7s | %4s | %10s | %10s | %s\n",
            "prob", "n", "solver", "ret", "nf", "njac", "nsolve", "bt", "avg_t(s)", "||f||", "title")
    println("---------------------------------------------------------------------------------------------------------------------")

    probs = NonlinearProblemLibrary.problems
    dicts = NonlinearProblemLibrary.dicts

    for idx in eachindex(probs)
        prob_fun = probs[idx]
        meta = dicts[idx]
        x0 = copy(meta["start"])
        n = length(x0)
        title = get(meta, "title", "")

        nlprob = NonlinearProblem(
            (u, p) -> begin
                out = similar(u)
                prob_fun(out, u, nothing)
                out
            end,
            x0,
            nothing,
        )

        tr_res = run_solver(nlprob, alg_tr; bt_steps_default = 0)
        nr_res = run_solver(nlprob, alg_nr; bt_steps_default = 0)
        nr_bt_res = run_solver(nlprob, alg_nr_bt; bt_steps_default = 0)

        @printf(" %4d | %4d | %8s | %4s | %6d | %6d | %7d | %4d | %10.3e | %10.3e | %s\n",
                idx, n, "TR", string(tr_res.ret), tr_res.nf, tr_res.njac, tr_res.nsolve, tr_res.bt, tr_res.avg_t, tr_res.fnorm, title)
        @printf(" %4d | %4d | %8s | %4s | %6d | %6d | %7d | %4d | %10.3e | %10.3e | %s\n",
                idx, n, "NR", string(nr_res.ret), nr_res.nf, nr_res.njac, nr_res.nsolve, nr_res.bt, nr_res.avg_t, nr_res.fnorm, title)
        @printf(" %4d | %4d | %8s | %4s | %6d | %6d | %7d | %4d | %10.3e | %10.3e | %s\n",
                idx, n, "NR_BT", string(nr_bt_res.ret), nr_bt_res.nf, nr_bt_res.njac, nr_bt_res.nsolve, nr_bt_res.bt, nr_bt_res.avg_t, nr_bt_res.fnorm, title)
    end
end

main()
