program compare_newton_fortran
    use iso_fortran_env, only: real64
    use nonlinearsolve
    implicit none

    integer, parameter :: dp = real64
    integer, parameter :: n = 2
    integer, parameter :: reps = 10
    real(dp) :: u(n), u0(n)
    real(dp) :: fval(n)
    type(newton_opts) :: opts_plain, opts_bt
    type(newton_stats) :: stats_plain, stats_bt
    real(dp) :: t_start, t_end, fnorm
    real(dp) :: time_plain, time_bt
    integer :: k

    u0 = [1.5_dp, -0.5_dp]

    opts_plain%abs_tol = 1.0e-10_dp
    opts_plain%rel_tol = 1.0e-10_dp
    opts_plain%max_iters = 100
    opts_plain%stagnation_iters = 100
    opts_plain%use_backtracking = .false.

    opts_bt = opts_plain
    opts_bt%use_backtracking = .true.
    opts_bt%bt_max_steps = 50

    ! Plain Newton timing
    call cpu_time(t_start)
    do k = 1, reps
        u = u0
        stats_plain = newton_stats()
        call newton_solve(residual, jacobian, u, opts_plain, stats_plain)
    end do
    call cpu_time(t_end)
    time_plain = (t_end - t_start) / real(reps, dp)
    call residual(u, fval)
    fnorm = sqrt(sum(fval * fval))

    print *, "=== Fortran Newton (no backtracking) ==="
    print '(a,2es24.16)', "solution u =", u
    print '(a,es24.16)', "||u|| =", sqrt(sum(u * u))
    print '(a,es24.16)', "||f(u)|| =", fnorm
    print '(a,es24.16)', "avg solve time (s) =", time_plain
    print '(a,i6)', "retcode =", stats_plain%retcode
    print '(a,i6)', "iters =", stats_plain%iters
    print '(a,i6)', "func evals =", stats_plain%func_evals
    print '(a,i6)', "jac evals =", stats_plain%jac_evals
    print '(a,i6)', "lin solves =", stats_plain%lin_solves
    print '(a,i6)', "backtrack steps =", stats_plain%backtrack_steps
    print '(a,l1)', "converged =", stats_plain%converged

    ! Newton with backtracking timing
    call cpu_time(t_start)
    do k = 1, reps
        u = u0
        stats_bt = newton_stats()
        call newton_solve(residual, jacobian, u, opts_bt, stats_bt)
    end do
    call cpu_time(t_end)
    time_bt = (t_end - t_start) / real(reps, dp)
    call residual(u, fval)
    fnorm = sqrt(sum(fval * fval))

    print *, "=== Fortran Newton (with backtracking) ==="
    print '(a,2es24.16)', "solution u =", u
    print '(a,es24.16)', "||u|| =", sqrt(sum(u * u))
    print '(a,es24.16)', "||f(u)|| =", fnorm
    print '(a,es24.16)', "avg solve time (s) =", time_bt
    print '(a,i6)', "retcode =", stats_bt%retcode
    print '(a,i6)', "iters =", stats_bt%iters
    print '(a,i6)', "func evals =", stats_bt%func_evals
    print '(a,i6)', "jac evals =", stats_bt%jac_evals
    print '(a,i6)', "lin solves =", stats_bt%lin_solves
    print '(a,i6)', "backtrack steps =", stats_bt%backtrack_steps
    print '(a,l1)', "converged =", stats_bt%converged

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

end program compare_newton_fortran
