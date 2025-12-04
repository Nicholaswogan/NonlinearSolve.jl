using ReTestItems

@testitem "Fortran vs Julia parity" tags=[:core] begin
    using Test
    using LinearAlgebra

    include(joinpath(@__DIR__, "test_nonlin.jl"))

    const FORTRAN_SRC = joinpath(@__DIR__, "test_nonlin.f90")
    const DRIVER_SRC = joinpath(@__DIR__, "fortran_compare_driver.f90")

    function build_and_run_fortran()
        mktempdir() do dir
            exe = joinpath(dir, "driver")
            run(`gfortran -O0 -std=f2008 $FORTRAN_SRC $DRIVER_SRC -o $exe`)
            return read(`$exe`, String)
        end
    end

    function parse_fortran_output(text::String)
        lines = filter(!isempty, split(text, '\n'))
        records = Dict{Int, NamedTuple}()
        i = 1
        while i <= length(lines)
            @assert startswith(lines[i], "P:")
            p = parse(Int, lines[i][3:end])
            title = replace(lines[i + 1], "TITLE:" => "") |> strip
            n = parse(Int, lines[i + 2][3:end])
            x = parse.(Float64, split(strip(replace(lines[i + 3], "X:" => ""))))
            f = parse.(Float64, split(strip(replace(lines[i + 4], "F:" => ""))))
            jac = zeros(Float64, n, n)
            for r in 1:n
                row = parse.(Float64, split(strip(replace(lines[i + 4 + r], "J:" => ""))))
                jac[r, :] .= row
            end
            records[p] = (title = title, n = n, x = x, f = f, jac = jac)
            i += 4 + n + 1
        end
        return records
    end

    ft_records = parse_fortran_output(build_and_run_fortran())

    function julia_record(problem::Int)
        nval = p00_n(problem)
        n = abs(nval)
        x = p00_start(problem, n)
        f = p00_fx(problem, n, x)
        jac = p00_jac(problem, n, x)
        return (title = p00_title(problem), n = n, x = collect(x), f = collect(f),
                jac = Array(jac))
    end

    for problem in 1:23
        fr = ft_records[problem]
        jr = julia_record(problem)

        @test jr.title == fr.title
        @test jr.n == fr.n
        @test jr.x ≈ fr.x rtol = 1e-10 atol = 1e-12
        @test jr.f ≈ fr.f rtol = 1e-10 atol = 1e-12
        @test jr.jac ≈ fr.jac rtol = 1e-10 atol = 1e-12
    end
end
