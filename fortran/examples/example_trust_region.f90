program example_trust_region
    use iso_fortran_env, only: real64
    use nonlinearsolve
    implicit none

    integer, parameter :: dp = real64
    integer, parameter :: n = 2
    real(dp) :: u(n) = [1.5_dp, -0.5_dp]
    type(trust_region_opts) :: opts
    type(trust_region_stats) :: stats

    opts%max_iters = 50
    opts%abs_tol = 1.0e-10_dp
    opts%rel_tol = 1.0e-10_dp

    call trust_region_solve(residual, jacobian, u, opts, stats)

    print '(a,2f12.6)', 'solution u =', u
    print '(a,i4,1x,i4,1x,l1)', 'retcode/iters/converged =', stats%retcode, stats%iters, stats%converged

contains

    subroutine residual(u, f)
        real(dp), intent(in) :: u(:)
        real(dp), intent(out) :: f(:)

        f(1) = u(1) * u(1) + u(2) * u(2) - 1.0_dp
        f(2) = u(1) - u(2)
    end subroutine residual

    subroutine jacobian(u, J)
        real(dp), intent(in) :: u(:)
        real(dp), intent(out) :: J(:, :)

        J(1, 1) = 2.0_dp * u(1)
        J(1, 2) = 2.0_dp * u(2)
        J(2, 1) = 1.0_dp
        J(2, 2) = -1.0_dp
    end subroutine jacobian

end program example_trust_region
