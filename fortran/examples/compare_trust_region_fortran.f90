program compare_trust_region_fortran
    use iso_fortran_env, only: real64
    use trust_region_nls
    implicit none

    integer, parameter :: dp = real64
    integer, parameter :: n = 2
    integer, parameter :: reps = 100
    real(dp) :: u(n), u0(n)
    type(trust_region_opts) :: opts
    type(trust_region_stats) :: stats
    real(dp) :: t_start, t_end, fnorm
    real(dp) :: fval(n)
    real(dp) :: total_time
    integer :: k

    opts%max_iters = 100
    opts%abs_tol = 1.0e-10_dp
    opts%rel_tol = 1.0e-10_dp

    u0 = [1.5_dp, -0.5_dp]
    total_time = 0.0_dp

    ! Run once for stats and accumulate timing over multiple repeats.
    call cpu_time(t_start)
    do k = 1, reps
        u = u0
        stats = trust_region_stats()
        call trust_region_solve(residual, jacobian, u, opts, stats)
    end do
    call cpu_time(t_end)
    total_time = t_end - t_start

    call residual(u, fval)
    fnorm = vec_norm2_local(fval)

    print *, "=== Fortran TrustRegion (NLsolve) ==="
    print '(a,2es24.16)', "solution u =", u
    print '(a,es24.16)', "||u|| =", vec_norm2_local(u)
    print '(a,es24.16)', "||f(u)|| =", fnorm
    print '(a,es24.16)', "avg solve time (s) =", total_time / real(reps, dp)
    print '(a,i6)', "retcode =", stats%retcode
    print '(a,i6)', "iters =", stats%iters
    print '(a,i6)', "func evals =", stats%func_evals
    print '(a,i6)', "jac evals =", stats%jac_evals
    print '(a,i6)', "lin solves =", stats%lin_solves
    print '(a,i6)', "shrink counter =", stats%shrink_steps
    print '(a,l1)', "converged =", stats%converged

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

    pure real(dp) function vec_norm2_local(x)
        real(dp), intent(in) :: x(:)
        vec_norm2_local = sqrt(sum(x * x))
    end function vec_norm2_local

end program compare_trust_region_fortran
