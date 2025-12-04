# Julia translation of fortran/examples/test_nonlin.f90
using LinearAlgebra

const rk = Float64
const EPS_FD = 1.0e-4

"""
    p00_problem_num()

Return the number of available test problems.
"""
p00_problem_num() = 23

"""
    p00_n(problem)

Return the size `n` for a given problem. A negative value indicates the
minimum size, matching the Fortran convention.
"""
function p00_n(problem::Integer)
    if     problem == 1
        return p01_n()
    elseif problem == 2
        return p02_n()
    elseif problem == 3
        return p03_n()
    elseif problem == 4
        return p04_n()
    elseif problem == 5
        return p05_n()
    elseif problem == 6
        return p06_n()
    elseif problem == 7
        return p07_n()
    elseif problem == 8
        return p08_n()
    elseif problem == 9
        return p09_n()
    elseif problem == 10
        return p10_n()
    elseif problem == 11
        return p11_n()
    elseif problem == 12
        return p12_n()
    elseif problem == 13
        return p13_n()
    elseif problem == 14
        return p14_n()
    elseif problem == 15
        return p15_n()
    elseif problem == 16
        return p16_n()
    elseif problem == 17
        return p17_n()
    elseif problem == 18
        return p18_n()
    elseif problem == 19
        return p19_n()
    elseif problem == 20
        return p20_n()
    elseif problem == 21
        return p21_n()
    elseif problem == 22
        return p22_n()
    elseif problem == 23
        return p23_n()
    else
        error("Illegal problem number = $problem")
    end
end

"""
    p00_title(problem)

Return the title string for the selected problem.
"""
function p00_title(problem::Integer)
    if     problem == 1
        return p01_title()
    elseif problem == 2
        return p02_title()
    elseif problem == 3
        return p03_title()
    elseif problem == 4
        return p04_title()
    elseif problem == 5
        return p05_title()
    elseif problem == 6
        return p06_title()
    elseif problem == 7
        return p07_title()
    elseif problem == 8
        return p08_title()
    elseif problem == 9
        return p09_title()
    elseif problem == 10
        return p10_title()
    elseif problem == 11
        return p11_title()
    elseif problem == 12
        return p12_title()
    elseif problem == 13
        return p13_title()
    elseif problem == 14
        return p14_title()
    elseif problem == 15
        return p15_title()
    elseif problem == 16
        return p16_title()
    elseif problem == 17
        return p17_title()
    elseif problem == 18
        return p18_title()
    elseif problem == 19
        return p19_title()
    elseif problem == 20
        return p20_title()
    elseif problem == 21
        return p21_title()
    elseif problem == 22
        return p22_title()
    elseif problem == 23
        return p23_title()
    else
        error("Illegal problem number = $problem")
    end
end

"""
    p00_start(problem, n)

Return the standard starting vector for a problem.
"""
function p00_start(problem::Integer, n::Integer)
    x = zeros(rk, n)
    if     problem == 1
        p01_start(n, x)
    elseif problem == 2
        p02_start(n, x)
    elseif problem == 3
        p03_start(n, x)
    elseif problem == 4
        p04_start(n, x)
    elseif problem == 5
        p05_start(n, x)
    elseif problem == 6
        p06_start(n, x)
    elseif problem == 7
        p07_start(n, x)
    elseif problem == 8
        p08_start(n, x)
    elseif problem == 9
        p09_start(n, x)
    elseif problem == 10
        p10_start(n, x)
    elseif problem == 11
        p11_start(n, x)
    elseif problem == 12
        p12_start(n, x)
    elseif problem == 13
        p13_start(n, x)
    elseif problem == 14
        p14_start(n, x)
    elseif problem == 15
        p15_start(n, x)
    elseif problem == 16
        p16_start(n, x)
    elseif problem == 17
        p17_start(n, x)
    elseif problem == 18
        p18_start(n, x)
    elseif problem == 19
        p19_start(n, x)
    elseif problem == 20
        p20_start(n, x)
    elseif problem == 21
        p21_start(n, x)
    elseif problem == 22
        p22_start(n, x)
    elseif problem == 23
        p23_start(n, x)
    else
        error("Illegal problem number = $problem")
    end
    return x
end

"""
    p00_sol(problem, n)

Return `(iknow, x)` describing known solutions for a problem.
"""
function p00_sol(problem::Integer, n::Integer)
    x = zeros(rk, n)
    iknow = 0
    if     problem == 1
        iknow = p01_sol(n, x)
    elseif problem == 2
        iknow = p02_sol(n, x)
    elseif problem == 3
        iknow = p03_sol(n, x)
    elseif problem == 4
        iknow = p04_sol(n, x)
    elseif problem == 5
        iknow = p05_sol(n, x)
    elseif problem == 6
        iknow = p06_sol(n, x)
    elseif problem == 7
        iknow = p07_sol(n, x)
    elseif problem == 8
        iknow = p08_sol(n, x)
    elseif problem == 9
        iknow = p09_sol(n, x)
    elseif problem == 10
        iknow = p10_sol(n, x)
    elseif problem == 11
        iknow = p11_sol(n, x)
    elseif problem == 12
        iknow = p12_sol(n, x)
    elseif problem == 13
        iknow = p13_sol(n, x)
    elseif problem == 14
        iknow = p14_sol(n, x)
    elseif problem == 15
        iknow = p15_sol(n, x)
    elseif problem == 16
        iknow = p16_sol(n, x)
    elseif problem == 17
        iknow = p17_sol(n, x)
    elseif problem == 18
        iknow = p18_sol(n, x)
    elseif problem == 19
        iknow = p19_sol(n, x)
    elseif problem == 20
        iknow = p20_sol(n, x)
    elseif problem == 21
        iknow = p21_sol(n, x)
    elseif problem == 22
        iknow = p22_sol(n, x)
    elseif problem == 23
        iknow = p23_sol(n, x)
    else
        error("Illegal problem number = $problem")
    end
    return iknow, x
end

"""
    p00_fx(problem, n, x, f)

Evaluate the nonlinear function for any problem. Overload returning a fresh
vector when `f` is omitted.
"""
function p00_fx(problem::Integer, n::Integer, x::AbstractVector{<:Real})
    f = zeros(rk, n)
    p00_fx(problem, n, x, f)
    return f
end

function p00_fx(problem::Integer, n::Integer, x::AbstractVector{<:Real}, f::AbstractVector)
    if     problem == 1
        p01_fx(n, x, f)
    elseif problem == 2
        p02_fx(n, x, f)
    elseif problem == 3
        p03_fx(n, x, f)
    elseif problem == 4
        p04_fx(n, x, f)
    elseif problem == 5
        p05_fx(n, x, f)
    elseif problem == 6
        p06_fx(n, x, f)
    elseif problem == 7
        p07_fx(n, x, f)
    elseif problem == 8
        p08_fx(n, x, f)
    elseif problem == 9
        p09_fx(n, x, f)
    elseif problem == 10
        p10_fx(n, x, f)
    elseif problem == 11
        p11_fx(n, x, f)
    elseif problem == 12
        p12_fx(n, x, f)
    elseif problem == 13
        p13_fx(n, x, f)
    elseif problem == 14
        p14_fx(n, x, f)
    elseif problem == 15
        p15_fx(n, x, f)
    elseif problem == 16
        p16_fx(n, x, f)
    elseif problem == 17
        p17_fx(n, x, f)
    elseif problem == 18
        p18_fx(n, x, f)
    elseif problem == 19
        p19_fx(n, x, f)
    elseif problem == 20
        p20_fx(n, x, f)
    elseif problem == 21
        p21_fx(n, x, f)
    elseif problem == 22
        p22_fx(n, x, f)
    elseif problem == 23
        p23_fx(n, x, f)
    else
        error("Illegal problem number = $problem")
    end
    return f
end

"""
    p00_jac(problem, n, x, fjac)

Evaluate the analytic Jacobian for any problem. Returns a new matrix when
`fjac` is omitted.
"""
function p00_jac(problem::Integer, n::Integer, x::AbstractVector{<:Real})
    fjac = zeros(rk, n, n)
    p00_jac(problem, n, x, fjac)
    return fjac
end

function p00_jac(problem::Integer, n::Integer, x::AbstractVector{<:Real}, fjac::AbstractMatrix)
    if     problem == 1
        p01_jac(n, x, fjac)
    elseif problem == 2
        p02_jac(n, x, fjac)
    elseif problem == 3
        p03_jac(n, x, fjac)
    elseif problem == 4
        p04_jac(n, x, fjac)
    elseif problem == 5
        p05_jac(n, x, fjac)
    elseif problem == 6
        p06_jac(n, x, fjac)
    elseif problem == 7
        p07_jac(n, x, fjac)
    elseif problem == 8
        p08_jac(n, x, fjac)
    elseif problem == 9
        p09_jac(n, x, fjac)
    elseif problem == 10
        p10_jac(n, x, fjac)
    elseif problem == 11
        p11_jac(n, x, fjac)
    elseif problem == 12
        p12_jac(n, x, fjac)
    elseif problem == 13
        p13_jac(n, x, fjac)
    elseif problem == 14
        p14_jac(n, x, fjac)
    elseif problem == 15
        p15_jac(n, x, fjac)
    elseif problem == 16
        p16_jac(n, x, fjac)
    elseif problem == 17
        p17_jac(n, x, fjac)
    elseif problem == 18
        p18_jac(n, x, fjac)
    elseif problem == 19
        p19_jac(n, x, fjac)
    elseif problem == 20
        p20_jac(n, x, fjac)
    elseif problem == 21
        p21_jac(n, x, fjac)
    elseif problem == 22
        p22_jac(n, x, fjac)
    elseif problem == 23
        p23_jac(n, x, fjac)
    else
        error("Illegal problem number = $problem")
    end
    return fjac
end

"""
    p00_dif(problem, n, x, fjac)

Approximate the Jacobian via forward finite differences. Returns a new matrix
when `fjac` is omitted. The input `x` is not mutated.
"""
function p00_dif(problem::Integer, n::Integer, x::AbstractVector{<:Real})
    fjac = zeros(rk, n, n)
    p00_dif(problem, n, copy(x), fjac)
    return fjac
end

function p00_dif(problem::Integer, n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    f = zeros(rk, n)
    fplus = similar(f)
    p00_fx(problem, n, x, f)
    for j in 1:n
        dxj = x[j] >= 0 ? EPS_FD * (x[j] + 1.0) : EPS_FD * (x[j] - 1.0)
        xsave = x[j]
        x[j] = xsave + dxj
        p00_fx(problem, n, x, fplus)
        fjac[:, j] .= (fplus .- f) ./ dxj
        x[j] = xsave
    end
    return fjac
end

# Problem 1
function p01_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    f[1] = 1.0 - x[1]
    for i in 2:n
        f[i] = 10.0 * (x[i] - x[i - 1]^2)
    end
    return f
end

p01_n() = -2

function p01_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    fill!(fjac, 0.0)
    fjac[1, 1] = -1.0
    for i in 2:n
        fjac[i, i - 1] = -20.0 * x[i - 1]
        fjac[i, i] = 10.0
    end
    return fjac
end

function p01_sol(n::Integer, x::AbstractVector)
    fill!(x, 1.0)
    return 1
end

function p01_start(n::Integer, x::AbstractVector)
    x[1] = -1.2
    for i in 2:n
        x[i] = 1.0
    end
    return x
end

p01_title() = "Generalized Rosenbrock function."

# Problem 2
function p02_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    f[1] = x[1] + 10.0 * x[2]
    f[2] = sqrt(5.0) * (x[3] - x[4])
    f[3] = (x[2] - 2.0 * x[3])^2
    f[4] = sqrt(10.0) * (x[1] - x[4])^2
    return f
end

p02_n() = 4

function p02_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    fjac[1, 1] = 1.0
    fjac[1, 2] = 10.0
    fjac[1, 3] = 0.0
    fjac[1, 4] = 0.0

    fjac[2, 1] = 0.0
    fjac[2, 2] = 0.0
    fjac[2, 3] = sqrt(5.0)
    fjac[2, 4] = -sqrt(5.0)

    fjac[3, 1] = 0.0
    fjac[3, 2] = 2.0 * (x[2] - 2.0 * x[3])
    fjac[3, 3] = -4.0 * (x[2] - 2.0 * x[3])
    fjac[3, 4] = 0.0

    fjac[4, 1] = 2.0 * sqrt(10.0) * (x[1] - x[4])
    fjac[4, 2] = 0.0
    fjac[4, 3] = 0.0
    fjac[4, 4] = -2.0 * sqrt(10.0) * (x[1] - x[4])
    return fjac
end

function p02_sol(n::Integer, x::AbstractVector)
    fill!(x, 0.0)
    return 1
end

function p02_start(n::Integer, x::AbstractVector)
    x[1] = 3.0
    x[2] = -1.0
    x[3] = 0.0
    x[4] = 1.0
    return x
end

p02_title() = "Powell singular function."

# Problem 3
function p03_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    f[1] = 10000.0 * x[1] * x[2] - 1.0
    f[2] = exp(-x[1]) + exp(-x[2]) - 1.0001
    return f
end

p03_n() = 2

function p03_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    fjac[1, 1] = 10000.0 * x[2]
    fjac[1, 2] = 10000.0 * x[1]
    fjac[2, 1] = -exp(-x[1])
    fjac[2, 2] = -exp(-x[2])
    return fjac
end

function p03_sol(n::Integer, x::AbstractVector)
    x[1:2] .= [1.098159e-05, 9.106146]
    return 1
end

function p03_start(n::Integer, x::AbstractVector)
    x[1:2] .= [0.0, 1.0]
    return x
end

p03_title() = "Powell badly scaled function."

# Problem 4
function p04_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    temp1 = x[2] - x[1]^2
    temp2 = x[4] - x[3]^2
    f[1] = -200.0 * x[1] * temp1 - (1.0 - x[1])
    f[2] = 200.0 * temp1 + 20.2 * (x[2] - 1.0) + 19.8 * (x[4] - 1.0)
    f[3] = -180.0 * x[3] * temp2 - (1.0 - x[3])
    f[4] = 180.0 * temp2 + 20.2 * (x[4] - 1.0) + 19.8 * (x[2] - 1.0)
    return f
end

p04_n() = 4

function p04_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    fill!(fjac, 0.0)
    fjac[1, 1] = -200.0 * (x[2] - 3.0 * x[1]^2) + 1.0
    fjac[1, 2] = -200.0 * x[1]
    fjac[1, 3] = 0.0
    fjac[1, 4] = 0.0

    fjac[2, 1] = -400.0 * x[1]
    fjac[2, 2] = 220.2
    fjac[2, 3] = 0.0
    fjac[2, 4] = 19.8

    fjac[3, 1] = 0.0
    fjac[3, 2] = 0.0
    fjac[3, 3] = -180.0 * (x[4] - 3.0 * x[3]^2) + 1.0
    fjac[3, 4] = -180.0 * x[3]

    fjac[4, 1] = 0.0
    fjac[4, 2] = 19.8
    fjac[4, 3] = -360.0 * x[3]
    fjac[4, 4] = 300.2
    return fjac
end

function p04_sol(n::Integer, x::AbstractVector)
    x[1:4] .= 1.0
    return 1
end

function p04_start(n::Integer, x::AbstractVector)
    x[1:4] .= [-3.0, -1.0, -3.0, -1.0]
    return x
end

p04_title() = "Wood function."

# Problem 5
function p05_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    if x[1] > 0.0
        temp = atan(x[2] / x[1]) / (2.0 * pi)
    elseif x[1] < 0.0
        temp = atan(x[2] / x[1]) / (2.0 * pi) + 0.5
    else
        temp = copysign(0.25, x[2])
    end

    f[1] = 10.0 * (x[3] - 10.0 * temp)
    f[2] = 10.0 * (sqrt(x[1]^2 + x[2]^2) - 1.0)
    f[3] = x[3]
    return f
end

p05_n() = 3

function p05_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    fjac[1, 1] = 100.0 * x[2] / (2.0 * pi * (x[1]^2 + x[2]^2))
    fjac[1, 2] = -100.0 * x[1] / (2.0 * pi * (x[1]^2 + x[2]^2))
    fjac[1, 3] = 10.0

    fjac[2, 1] = 10.0 * x[1] / sqrt(x[1]^2 + x[2]^2)
    fjac[2, 2] = 10.0 * x[2] / sqrt(x[1]^2 + x[2]^2)
    fjac[2, 3] = 0.0

    fjac[3, 1] = 0.0
    fjac[3, 2] = 0.0
    fjac[3, 3] = 1.0
    return fjac
end

function p05_sol(n::Integer, x::AbstractVector)
    x[1:3] .= [1.0, 0.0, 0.0]
    return 1
end

function p05_start(n::Integer, x::AbstractVector)
    x[1:3] .= [-1.0, 0.0, 0.0]
    return x
end

p05_title() = "Helical valley function."

# Problem 6
function p06_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    fill!(f, 0.0)
    for i in 1:29
        ti = i / 29.0
        sum1 = 0.0
        temp = 1.0
        for j in 2:n
            sum1 += (j - 1) * temp * x[j]
            temp *= ti
        end

        sum2 = 0.0
        temp = 1.0
        for j in 1:n
            sum2 += temp * x[j]
            temp *= ti
        end

        temp = 1.0 / ti
        for k in 1:n
            f[k] += temp * (sum1 - sum2 * sum2 - 1.0) * ((k - 1) - 2.0 * ti * sum2)
            temp *= ti
        end
    end

    f[1] += 3.0 * x[1] - 2.0 * x[1] * x[2] + 2.0 * x[1]^3
    f[2] += x[2] - x[1]^2 - 1.0
    return f
end

p06_n() = -2

function p06_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    fill!(fjac, 0.0)
    for i in 1:29
        ti = i / 29.0

        sum1 = 0.0
        temp = 1.0
        for j in 2:n
            sum1 += (j - 1) * temp * x[j]
            temp *= ti
        end

        sum2 = 0.0
        temp = 1.0
        for j in 1:n
            sum2 += temp * x[j]
            temp *= ti
        end

        temp1 = 2.0 * (sum1 - sum2 * sum2 - 1.0)
        tk = 1.0
        for k in 1:n
            tj = tk
            for j in k:n
                fjac[k, j] += tj * (((k - 1) / ti - 2.0 * sum2) * ((j - 1) / ti - 2.0 * sum2) - temp1)
                tj *= ti
            end
            tk *= ti^2
        end
    end

    fjac[1, 1] += 3.0 - 2.0 * x[2] + 6.0 * x[1]^2
    fjac[1, 2] += -2.0 * x[1]
    fjac[2, 1] += -2.0 * x[1]
    fjac[2, 2] += 1.0

    for k in 1:n
        for j in k:n
            fjac[j, k] = fjac[k, j]
        end
    end
    return fjac
end

function p06_sol(n::Integer, x::AbstractVector)
    fill!(x, 0.0)
    return 0
end

function p06_start(n::Integer, x::AbstractVector)
    fill!(x, 0.0)
    return x
end

p06_title() = "Watson function."

# Problem 7
function p07_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    fill!(f, 0.0)
    for j in 1:n
        t1 = 1.0
        t2 = x[j]
        for i in 1:n
            f[i] += t2
            t3 = 2.0 * x[j] * t2 - t1
            t1 = t2
            t2 = t3
        end
    end

    for i in 1:n
        f[i] /= n
        if iseven(i)
            f[i] += 1.0 / (i * i - 1)
        end
    end
    return f
end

p07_n() = 9

function p07_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    for j in 1:n
        t1 = 1.0
        t2 = x[j]
        t4 = 0.0
        t5 = 1.0
        for i in 1:n
            fjac[i, j] = t5
            t6 = 2.0 * t2 + 2.0 * t5 * x[j] - t4
            t4 = t5
            t5 = t6
            t3 = 2.0 * x[j] * t2 - t1
            t1 = t2
            t2 = t3
        end
    end

    for i in 1:n, j in 1:n
        fjac[i, j] /= n
    end
    return fjac
end

function p07_sol(n::Integer, x::AbstractVector)
    if n == 1
        x[1] = 0.5
        iknow = 1
    elseif n == 2
        x[1:2] .= [0.2113248654051871, 0.7886751345948129]
        iknow = 1
    elseif n == 3
        x[1:3] .= [0.1464466094067263, 0.5, 0.8535533905932737]
        iknow = 1
    elseif n == 4
        x[1:4] .= [0.10267276385, 0.40620376295, 0.59379623705, 0.89732723615]
        iknow = 1
    elseif n == 5
        x[1:5] .= [0.0837512565, 0.3127292952, 0.5, 0.6872707048, 0.9162487435]
        iknow = 1
    elseif n == 6
        x[1:6] .= [0.06687659095, 0.2887406731, 0.36668229925, 0.63331770075, 0.7112593269, 0.93312340905]
        iknow = 1
    elseif n == 7
        x[1:7] .= [0.0580691496, 0.23517161235, 0.33804409475, 0.5, 0.66195590525, 0.76482838765, 0.9419308504]
        iknow = 1
    elseif n == 9
        x[1:9] .= [0.04420534615, 0.1994906723, 0.23561910845, 0.4160469079, 0.5, 0.5839530921, 0.76438089155, 0.8005093277, 0.95579465385]
        iknow = 1
    else
        fill!(x, 0.5)
        iknow = -1
    end

    for i in 1:n
        x[i] = 2.0 * x[i] - 1.0
    end
    return iknow
end

function p07_start(n::Integer, x::AbstractVector)
    for i in 1:n
        x[i] = (2 * i - 1 - n) / (n + 1)
    end
    return x
end

p07_title() = "Chebyquad function."

# Problem 8
function p08_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    total = sum(view(x, 1:n))
    for i in 1:n-1
        f[i] = x[i] + total - (n + 1)
    end
    f[n] = prod(view(x, 1:n)) - 1.0
    return f
end

p08_n() = -1

function p08_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    fill!(fjac, 1.0)
    for i in 1:n-1
        fjac[i, i] = 2.0
    end
    fjac[n, :] .= 0.0
    for j in 1:n
        prod_val = 1.0
        for k in 1:n
            if k != j
                prod_val *= x[k]
            end
        end
        fjac[n, j] = prod_val
    end
    return fjac
end

function p08_sol(n::Integer, x::AbstractVector)
    fill!(x, 1.0)
    return 1
end

function p08_start(n::Integer, x::AbstractVector)
    fill!(x, 0.5)
    return x
end

p08_title() = "Brown almost linear function."

# Problem 9
function p09_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    h = 1.0 / (n + 1)
    for k in 1:n
        f[k] = 2.0 * x[k] + 0.5 * h^2 * (x[k] + k * h + 1.0)^3
        if k > 1
            f[k] -= x[k - 1]
        end
        if k < n
            f[k] -= x[k + 1]
        end
    end
    return f
end

p09_n() = -1

function p09_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    fill!(fjac, 0.0)
    for i in 1:n
        fjac[i, i] = 2.0 + 1.5 * (x[i] + 1.0 + i / (n + 1))^2 / (n + 1)^2
        if i > 1
            fjac[i, i - 1] = -1.0
        end
        if i < n
            fjac[i, i + 1] = -1.0
        end
    end
    return fjac
end

function p09_sol(n::Integer, x::AbstractVector)
    fill!(x, 0.0)
    return 0
end

function p09_start(n::Integer, x::AbstractVector)
    for i in 1:n
        x[i] = i * (i - n - 1) / (n + 1)^2
    end
    return x
end

p09_title() = "Discrete boundary value function."

# Problem 10
function p10_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    h = 1.0 / (n + 1)
    for k in 1:n
        tk = k / (n + 1)
        sum1 = 0.0
        for j in 1:k
            tj = j * h
            sum1 += tj * (x[j] + tj + 1.0)^3
        end
        sum2 = 0.0
        for j in k+1:n
            tj = j * h
            sum2 += (1.0 - tj) * (x[j] + tj + 1.0)^3
        end
        f[k] = x[k] + h * ((1.0 - tk) * sum1 + tk * sum2) / 2.0
    end
    return f
end

p10_n() = -1

function p10_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    for i in 1:n
        ti = i / (n + 1)
        for j in 1:n
            tj = j / (n + 1)
            temp1 = (x[j] + tj + 1.0)^2
            temp2 = min(ti, tj) - ti * tj
            fjac[i, j] = 1.5 * temp2 * temp1 / (n + 1)
        end
        fjac[i, i] += 1.0
    end
    return fjac
end

function p10_sol(n::Integer, x::AbstractVector)
    fill!(x, 0.0)
    return 0
end

function p10_start(n::Integer, x::AbstractVector)
    for i in 1:n
        x[i] = i * (i - n - 1) / (n + 1)^2
    end
    return x
end

p10_title() = "Discrete integral equation function."

# Problem 11
function p11_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    c_sum = sum(cos.(view(x, 1:n)))
    for k in 1:n
        f[k] = n - c_sum + k * (1.0 - cos(x[k])) - sin(x[k])
    end
    return f
end

p11_n() = -1

function p11_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    for i in 1:n
        for j in 1:n
            if i != j
                fjac[i, j] = sin(x[j])
            else
                fjac[i, j] = (j + 1) * sin(x[j]) - cos(x[j])
            end
        end
    end
    return fjac
end

function p11_sol(n::Integer, x::AbstractVector)
    fill!(x, 0.0)
    return 0
end

function p11_start(n::Integer, x::AbstractVector)
    fill!(x, 1.0 / n)
    return x
end

p11_title() = "Trigonometric function."

# Problem 12
function p12_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    sum1 = 0.0
    for j in 1:n
        sum1 += j * (x[j] - 1.0)
    end
    for k in 1:n
        f[k] = x[k] - 1.0 + k * sum1 * (1.0 + 2.0 * sum1^2)
    end
    return f
end

p12_n() = -1

function p12_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    sum1 = 0.0
    for i in 1:n
        sum1 += i * (x[i] - 1.0)
    end
    for i in 1:n
        for j in 1:n
            fjac[i, j] = i * j * (1.0 + 6.0 * sum1^2)
            if i == j
                fjac[i, j] += 1.0
            end
        end
    end
    return fjac
end

function p12_sol(n::Integer, x::AbstractVector)
    fill!(x, 1.0)
    return 1
end

function p12_start(n::Integer, x::AbstractVector)
    for i in 1:n
        x[i] = 1.0 - i / n
    end
    return x
end

p12_title() = "Variably dimensioned function."

# Problem 13
function p13_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    for k in 1:n
        f[k] = (3.0 - 2.0 * x[k]) * x[k] + 1.0
        if k > 1
            f[k] -= x[k - 1]
        end
        if k < n
            f[k] -= 2.0 * x[k + 1]
        end
    end
    return f
end

p13_n() = -1

function p13_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    fill!(fjac, 0.0)
    for k in 1:n
        fjac[k, k] = 3.0 - 4.0 * x[k]
        if k > 1
            fjac[k, k - 1] = -1.0
        end
        if k < n
            fjac[k, k + 1] = -2.0
        end
    end
    return fjac
end

function p13_sol(n::Integer, x::AbstractVector)
    fill!(x, 0.0)
    return 0
end

function p13_start(n::Integer, x::AbstractVector)
    fill!(x, -1.0)
    return x
end

p13_title() = "Broyden tridiagonal function."

# Problem 14
function p14_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    ml = 5
    mu = 1
    for k in 1:n
        k1 = max(1, k - ml)
        k2 = min(n, k + mu)
        temp = 0.0
        for j in k1:k2
            if j != k
                temp += x[j] * (1.0 + x[j])
            end
        end
        f[k] = x[k] * (2.0 + 5.0 * x[k]^2) + 1.0 - temp
    end
    return f
end

p14_n() = -1

function p14_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    fill!(fjac, 0.0)
    ml = 5
    mu = 1
    for k in 1:n
        k1 = max(1, k - ml)
        k2 = min(n, k + mu)
        for j in k1:k2
            if j != k
                fjac[k, j] = -(1.0 + 2.0 * x[j])
            else
                fjac[k, j] = 2.0 + 15.0 * x[k]^2
            end
        end
    end
    return fjac
end

function p14_sol(n::Integer, x::AbstractVector)
    fill!(x, 0.0)
    return 0
end

function p14_start(n::Integer, x::AbstractVector)
    fill!(x, -1.0)
    return x
end

p14_title() = "Broyden banded function."

# Problem 15
function p15_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    f[1] = x[1]^2 + x[2] * x[3] - 0.0001
    f[2] = x[1] * x[2] + x[2] * x[4] - 1.0
    f[3] = x[3] * x[1] + x[4] * x[3]
    f[4] = x[3] * x[2] + x[4]^2 - 0.0001
    return f
end

p15_n() = 4

function p15_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    fjac[1, 1] = 2.0 * x[1]
    fjac[1, 2] = x[3]
    fjac[1, 3] = x[2]
    fjac[1, 4] = 0.0

    fjac[2, 1] = x[2]
    fjac[2, 2] = x[1] + x[4]
    fjac[2, 3] = 0.0
    fjac[2, 4] = x[2]

    fjac[3, 1] = x[3]
    fjac[3, 2] = 0.0
    fjac[3, 3] = x[1] + x[4]
    fjac[3, 4] = x[3]

    fjac[4, 1] = 0.0
    fjac[4, 2] = x[3]
    fjac[4, 3] = x[2]
    fjac[4, 4] = 2.0 * x[4]
    return fjac
end

function p15_sol(n::Integer, x::AbstractVector)
    x[1:4] .= [0.01, 50.0, 0.0, 0.01]
    return 1
end

function p15_start(n::Integer, x::AbstractVector)
    x[1:4] .= [1.0, 0.0, 0.0, 1.0]
    return x
end

p15_title() = "Hammarling 2 by 2 matrix square root problem."

# Problem 16
function p16_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    f[1] = x[1]^2 + x[2] * x[4] + x[3] * x[7] - 0.0001
    f[2] = x[1] * x[2] + x[2] * x[5] + x[3] * x[8] - 1.0
    f[3] = x[1] * x[3] + x[2] * x[6] + x[3] * x[9]

    f[4] = x[4] * x[1] + x[5] * x[4] + x[6] * x[7]
    f[5] = x[4] * x[2] + x[5]^2 + x[6] * x[8] - 0.0001
    f[6] = x[4] * x[3] + x[5] * x[6] + x[6] * x[9]

    f[7] = x[7] * x[1] + x[8] * x[4] + x[9] * x[7]
    f[8] = x[7] * x[2] + x[8] * x[5] + x[9] * x[8]
    f[9] = x[7] * x[3] + x[8] * x[6] + x[9]^2 - 0.0001
    return f
end

p16_n() = 9

function p16_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    fill!(fjac, 0.0)
    fjac[1, 1] = 2.0 * x[1]
    fjac[1, 2] = x[4]
    fjac[1, 3] = x[7]
    fjac[1, 4] = x[2]
    fjac[1, 7] = x[3]

    fjac[2, 1] = x[2]
    fjac[2, 2] = x[1] + x[5]
    fjac[2, 3] = x[8]
    fjac[2, 5] = x[2]
    fjac[2, 8] = x[3]

    fjac[3, 1] = x[3]
    fjac[3, 2] = x[6]
    fjac[3, 3] = x[1] + x[9]
    fjac[3, 6] = x[2]
    fjac[3, 9] = x[3]

    fjac[4, 1] = x[4]
    fjac[4, 4] = x[1] + x[5]
    fjac[4, 5] = x[4]
    fjac[4, 6] = x[7]
    fjac[4, 7] = x[6]

    fjac[5, 2] = x[4]
    fjac[5, 4] = x[2]
    fjac[5, 5] = 2.0 * x[5]
    fjac[5, 6] = x[8]
    fjac[5, 8] = x[6]

    fjac[6, 3] = x[4]
    fjac[6, 4] = x[3]
    fjac[6, 5] = x[6]
    fjac[6, 6] = x[5] + x[9]
    fjac[6, 9] = x[6]

    fjac[7, 1] = x[7]
    fjac[7, 4] = x[8]
    fjac[7, 7] = x[1] + x[9]
    fjac[7, 8] = x[4]
    fjac[7, 9] = x[7]

    fjac[8, 2] = x[7]
    fjac[8, 5] = x[8]
    fjac[8, 7] = x[2]
    fjac[8, 8] = x[5] + x[9]
    fjac[8, 9] = x[8]

    fjac[9, 3] = x[7]
    fjac[9, 6] = x[8]
    fjac[9, 7] = x[3]
    fjac[9, 8] = x[6]
    fjac[9, 9] = 2.0 * x[9]
    return fjac
end

function p16_sol(n::Integer, x::AbstractVector)
    x[1] = 0.01
    x[2] = 50.0
    x[3] = 0.0
    x[4] = 0.0
    x[5] = 0.01
    x[6] = 0.0
    x[7] = 0.0
    x[8] = 0.0
    x[9] = 0.01
    return 1
end

function p16_start(n::Integer, x::AbstractVector)
    x[1] = 1.0
    x[2] = 0.0
    x[3] = 0.0
    x[4] = 0.0
    x[5] = 1.0
    x[6] = 0.0
    x[7] = 0.0
    x[8] = 0.0
    x[9] = 1.0
    return x
end

p16_title() = "Hammarling 3 by 3 matrix square root problem."

# Problem 17
function p17_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    f[1] = x[1] + x[2] - 3.0
    f[2] = x[1]^2 + x[2]^2 - 9.0
    return f
end

p17_n() = 2

function p17_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    fjac[1, 1] = 1.0
    fjac[1, 2] = 1.0
    fjac[2, 1] = 2.0 * x[1]
    fjac[2, 2] = 2.0 * x[2]
    return fjac
end

function p17_sol(n::Integer, x::AbstractVector)
    x[1] = 0.0
    x[2] = 3.0
    return 1
end

function p17_start(n::Integer, x::AbstractVector)
    x[1] = 1.0
    x[2] = 5.0
    return x
end

p17_title() = "Dennis and Schnabel 2 by 2 example."

# Problem 18
function p18_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    if x[1] != 0.0
        f[1] = x[2]^2 * (1.0 - exp(-x[1]^2)) / x[1]
    else
        f[1] = 0.0
    end

    if x[2] != 0.0
        f[2] = x[1] * (1.0 - exp(-x[2]^2)) / x[2]
    else
        f[2] = 0.0
    end
    return f
end

p18_n() = 2

function p18_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    if x[1] != 0.0
        fjac[1, 1] = x[2]^2 * (2.0 * exp(-x[1]^2) - (1.0 - exp(-x[1]^2)) / x[1]^2)
        fjac[1, 2] = 2.0 * x[2] * (1.0 - exp(-x[1]^2)) / x[1]
    else
        fjac[1, 1] = x[2]^2
        fjac[1, 2] = 0.0
    end

    if x[2] != 0.0
        fjac[2, 1] = (1.0 - exp(-x[2]^2)) / x[2]
        fjac[2, 2] = x[1] * (2.0 * exp(-x[2]^2) - (1.0 - exp(-x[2]^2)) / x[2]^2)
    else
        fjac[2, 1] = 0.0
        fjac[2, 2] = x[1]
    end
    return fjac
end

function p18_sol(n::Integer, x::AbstractVector)
    x[1] = 0.0
    x[2] = 0.0
    return 1
end

function p18_start(n::Integer, x::AbstractVector)
    x[1] = 2.0
    x[2] = 2.0
    return x
end

p18_title() = "Sample problem 18."

# Problem 19
function p19_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    f[1] = x[1] * (x[1]^2 + x[2]^2)
    f[2] = x[2] * (x[1]^2 + x[2]^2)
    return f
end

p19_n() = 2

function p19_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    fjac[1, 1] = 3.0 * x[1]^2 + x[2]^2
    fjac[1, 2] = 2.0 * x[1] * x[2]
    fjac[2, 1] = 2.0 * x[1] * x[2]
    fjac[2, 2] = x[1]^2 + 3.0 * x[2]^2
    return fjac
end

function p19_sol(n::Integer, x::AbstractVector)
    x[1] = 0.0
    x[2] = 0.0
    return 1
end

function p19_start(n::Integer, x::AbstractVector)
    x[1:2] .= 3.0
    return x
end

p19_title() = "Sample problem 19."

# Problem 20
const _p20_icall = Ref(0)
function p20_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    f[1] = x[1] * (x[1] - 5.0)^2
    return f
end

p20_n() = 1

function p20_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    fill!(fjac, 0.0)
    fjac[1, 1] = (3.0 * x[1] - 5.0) * (x[1] - 5.0)
    return fjac
end

function p20_sol(n::Integer, x::AbstractVector)
    iknow = 2
    idx = mod(_p20_icall[], iknow)
    _p20_icall[] += 1
    if idx == 0
        x[1] = 0.0
    else
        x[1] = 5.0
    end
    return iknow
end

function p20_start(n::Integer, x::AbstractVector)
    x[1] = 1.0
    return x
end

p20_title() = "Scalar problem f(x) = x * ( x - 5 ) * ( x - 5 )."

# Problem 21
function p21_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    f[1] = x[1] - x[2]^3 + 5.0 * x[2]^2 - 2.0 * x[2] - 13.0
    f[2] = x[1] + x[2]^3 + x[2]^2 - 14.0 * x[2] - 29.0
    return f
end

p21_n() = 2

function p21_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    fjac[1, 1] = 1.0
    fjac[1, 2] = -3.0 * x[2]^2 + 10.0 * x[2] - 2.0
    fjac[2, 1] = 1.0
    fjac[2, 2] = 3.0 * x[2]^2 + 2.0 * x[2] - 14.0
    return fjac
end

function p21_sol(n::Integer, x::AbstractVector)
    x[1] = 5.0
    x[2] = 4.0
    return 1
end

function p21_start(n::Integer, x::AbstractVector)
    x[1] = 0.5
    x[2] = -2.0
    return x
end

p21_title() = "Freudenstein-Roth function."

# Problem 22
function p22_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    f[1] = x[1]^2 - x[2] + 1.0
    f[2] = x[1] - cos(0.5 * pi * x[2])
    return f
end

p22_n() = 2

function p22_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    fjac[1, 1] = 2.0 * x[1]
    fjac[1, 2] = -1.0
    fjac[2, 1] = 1.0
    fjac[2, 2] = 0.5 * pi * sin(0.5 * pi * x[2])
    return fjac
end

function p22_sol(n::Integer, x::AbstractVector)
    x[1] = 0.0
    x[2] = 1.0
    return 1
end

function p22_start(n::Integer, x::AbstractVector)
    x[1:2] .= [1.0, 0.0]
    return x
end

p22_title() = "Boggs function."

# Problem 23
function p23_fx(n::Integer, x::AbstractVector, f::AbstractVector)
    c = 0.9
    mu = [(2 * i - 1) / (2 * n) for i in 1:n]
    for i in 1:n
        f[i] = x[i]
    end
    for i in 1:n
        term = 1.0 - c * sum(mu[i] * x[j] / (mu[i] + mu[j]) for j in 1:n) / (2 * n)
        f[i] -= 1.0 / term
    end
    return f
end

p23_n() = -1

function p23_jac(n::Integer, x::AbstractVector, fjac::AbstractMatrix)
    c = 0.9
    mu = [(2 * i - 1) / (2 * n) for i in 1:n]
    fill!(fjac, 0.0)
    for i in 1:n
        fjac[i, i] = 1.0
    end
    for i in 1:n
        term = 1.0 - c * sum(mu[i] * x[j] / (mu[i] + mu[j]) for j in 1:n) / (2 * n)
        for j in 1:n
            termp = c * mu[i] / (mu[i] + mu[j]) / (2 * n)
            fjac[i, j] -= (termp / term) / term
        end
    end
    return fjac
end

function p23_sol(n::Integer, x::AbstractVector)
    fill!(x, 0.0)
    return -1
end

function p23_start(n::Integer, x::AbstractVector)
    fill!(x, 1.0)
    return x
end

p23_title() = "Chandrasekhar function."

# Utilities
r8vec_norm2(a::AbstractVector) = sqrt(sum(abs2, a))

function r8ge_fa(a::AbstractMatrix)
    a_work = copy(a)
    return r8ge_fa!(a_work)
end

function r8ge_fa!(a::AbstractMatrix)
    n = size(a, 1)
    pivot = zeros(Int, n)
    info = 0
    for k in 1:n-1
        l = k
        for i in k+1:n
            if abs(a[l, k]) < abs(a[i, k])
                l = i
            end
        end
        pivot[k] = l
        if a[l, k] == 0.0
            info = k
            return a, pivot, info
        end
        if l != k
            a[l, k], a[k, k] = a[k, k], a[l, k]
        end
        a[k+1:n, k] .= -a[k+1:n, k] ./ a[k, k]
        for j in k+1:n
            if l != k
                a[l, j], a[k, j] = a[k, j], a[l, j]
            end
            a[k+1:n, j] .+= a[k+1:n, k] .* a[k, j]
        end
    end
    pivot[n] = n
    if a[n, n] == 0.0
        info = n
    end
    return a, pivot, info
end

function r8ge_sl(a_lu::AbstractMatrix, pivot::AbstractVector{Int}, b::AbstractVector; job::Integer=0)
    b_work = copy(b)
    return r8ge_sl!(a_lu, pivot, b_work; job=job)
end

function r8ge_sl!(a_lu::AbstractMatrix, pivot::AbstractVector{Int}, b::AbstractVector; job::Integer=0)
    n = length(b)
    if job == 0
        for k in 1:n-1
            l = pivot[k]
            if l != k
                b[l], b[k] = b[k], b[l]
            end
            b[k+1:n] .+= a_lu[k+1:n, k] .* b[k]
        end
        for k in n:-1:1
            b[k] /= a_lu[k, k]
            b[1:k-1] .-= a_lu[1:k-1, k] .* b[k]
        end
    else
        for k in 1:n
            b[k] = (b[k] - sum(b[1:k-1] .* a_lu[1:k-1, k])) / a_lu[k, k]
        end
        for k in n-1:-1:1
            b[k] += sum(b[k+1:n] .* a_lu[k+1:n, k])
            l = pivot[k]
            if l != k
                b[l], b[k] = b[k], b[l]
            end
        end
    end
    return b
end
