#!/usr/bin/env julia
using Pkg

const ROOT = normpath(@__DIR__, "..", "..")
Pkg.activate(ROOT)
Pkg.develop(PackageSpec(path = normpath(ROOT, "lib", "NonlinearSolveFirstOrder")))
Pkg.instantiate()

using BenchmarkTools
using LinearAlgebra
using NonlinearSolveFirstOrder
using SciMLBase
using LineSearch: BackTracking

function main()
    f = NonlinearFunction(
        (u, p) -> begin
            du = similar(u)
            du[1] = u[1]^2 + u[2]^2 - 1
            du[2] = u[1] - u[2]
            du
        end,
        jac = (u, p) -> begin
            J = zeros(eltype(u), 2, 2)
            J[1, 1] = 2 * u[1]
            J[1, 2] = 2 * u[2]
            J[2, 1] = 1
            J[2, 2] = -1
            J
        end
    )

    u0 = [1.5, -0.5]
    prob = NonlinearProblem(f, u0, nothing)

    alg_plain = NewtonRaphson()
    alg_bt = NewtonRaphson(linesearch = BackTracking())

    sol_plain = solve(prob, alg_plain; abstol = 1e-10, reltol = 1e-10)
    sol_bt = solve(prob, alg_bt; abstol = 1e-10, reltol = 1e-10)

    t_plain = @belapsed solve($prob, $alg_plain; abstol = 1e-10, reltol = 1e-10)
    t_bt = @belapsed solve($prob, $alg_bt; abstol = 1e-10, reltol = 1e-10)

    f_plain = prob.f(sol_plain.u, prob.p)
    f_bt = prob.f(sol_bt.u, prob.p)

    println("=== Julia NewtonRaphson (no backtracking) ===")
    println("solution u =", sol_plain.u)
    println("||u|| =", norm(sol_plain.u))
    println("||f(u)|| =", norm(f_plain))
    println("solve time (s) =", t_plain)
    println("retcode =", sol_plain.retcode)
    println("iters =", get_or(sol_plain.stats, :nsteps))
    println("func evals =", get_or(sol_plain.stats, :nf))
    println("jac evals =", get_or(sol_plain.stats, :njacs))
    println("lin solves =", get_or(sol_plain.stats, :nsolve))
    println()

    println("=== Julia NewtonRaphson (with backtracking) ===")
    println("solution u =", sol_bt.u)
    println("||u|| =", norm(sol_bt.u))
    println("||f(u)|| =", norm(f_bt))
    println("solve time (s) =", t_bt)
    println("retcode =", sol_bt.retcode)
    println("iters =", get_or(sol_bt.stats, :nsteps))
    println("func evals =", get_or(sol_bt.stats, :nf))
    println("jac evals =", get_or(sol_bt.stats, :njacs))
    println("lin solves =", get_or(sol_bt.stats, :nsolve))
end

get_or(x, name) = Base.hasproperty(x, name) ? getproperty(x, name) : "n/a"

main()
