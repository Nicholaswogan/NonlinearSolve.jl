#!/usr/bin/env julia
using Pkg
Pkg.activate(joinpath(@__DIR__, "..", ".."))

using LinearAlgebra
using NonlinearSolveFirstOrder
using SciMLBase

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
            J[1, 1] = 2u[1]
            J[1, 2] = 2u[2]
            J[2, 1] = 1
            J[2, 2] = -1
            J
        end
    )

    u0 = [1.5, -0.5]
    prob = NonlinearProblem(f, u0, nothing)
    alg = TrustRegion(radius_update_scheme = RadiusUpdateSchemes.NLsolve)

    t_start = time()
    sol = solve(prob, alg; abstol = 1e-10, reltol = 1e-10)
    elapsed = time() - t_start

    println("=== Julia TrustRegion (NLsolve) ===")
    println("solution u =", sol.u)
    println("||u|| =", norm(sol.u))
    println("solve time (s) =", elapsed)
    println("retcode =", sol.retcode)
    println("iters =", get_or(sol, :iters))
    println("func evals =", get_or(sol.stats, :nf))
    println("jac evals =", get_or(sol.stats, :nfJ))
    println("lin solves =", get_or(sol.stats, :nsolve))
    println("trace length =", length(sol.trace))
    println("stats fields =", propertynames(sol.stats))
end

get_or(x, name) = Base.hasproperty(x, name) ? getproperty(x, name) : "n/a"

main()
