program run_test_nonlin
    use iso_fortran_env, only: real64
    use nonlinearsolve
    use minpack_module, only: hybrj1, wp
    implicit none

    integer, parameter :: dp = real64
    integer, parameter :: nprob = 23
    integer, parameter :: reps = 100
    integer :: prob
    integer :: n_in, n
    integer :: k
    real(dp), allocatable :: u(:), u0(:), f(:), J(:, :)
    type(trust_region_opts) :: opts
    type(trust_region_stats) :: stats
    type(newton_opts) :: nopts, nopts_bt
    type(newton_stats) :: nstats, nstats_bt
    real(dp) :: t_start, t_end, fnorm_tr, fnorm_mp, fnorm_nr, fnorm_nr_bt
    real(dp) :: avg_time_tr, avg_time_mp, avg_time_nr, avg_time_nr_bt
    character(len=80) :: title
    ! Minpack workspace
    real(wp), allocatable :: x_mp(:), f_mp(:), jac_mp(:, :), wa(:)
    real(wp) :: tol_mp
    integer :: info_mp, lwa, ldfjac
    integer :: mp_nfev, mp_njac
    integer :: prob_current

    opts%abs_tol = 1.0e-10_dp
    opts%rel_tol = 1.0e-10_dp
    opts%max_iters = 200

    nopts = newton_opts()
    nopts_bt = newton_opts()
    nopts%abs_tol = opts%abs_tol
    nopts%rel_tol = opts%rel_tol
    nopts%max_iters = opts%max_iters
    nopts_bt = nopts
    nopts_bt%use_backtracking = .true.

    write (*,'(1x,a4,1x,"|",1x,a4,1x,"|",1x,a8,1x,"|",1x,a4,1x,"|",1x,a6,1x,"|",1x,a6,1x,"|",1x,a7,1x,"|",1x,a4,1x,"|",1x,a10,1x,"|",1x,a10,1x,"|",1x,a)') &
        "prob", "n", "solver", "ret", "nf", "njac", "nsolve", "bt", "avg_t(s)", "||f||", "title"
    print *, "---------------------------------------------------------------------------------------------------------------------"

    do prob = 1, nprob
        prob_current = prob
        call p00_title(prob, title)
        call p00_n(prob, n_in)
        n = abs(n_in)

        allocate(u(n), u0(n), f(n), J(n, n))
        call p00_start(prob, n, u)
        u0 = u

        ! Trust-region runs
        stats = trust_region_stats()
        call cpu_time(t_start)
        do k = 1, reps
            u = u0
            stats = trust_region_stats()
            call trust_region_solve(residual_wrapper, jac_wrapper, u, opts, stats)
        end do
        call cpu_time(t_end)
        avg_time_tr = (t_end - t_start) / real(reps, dp)
        call residual_wrapper(u, f)
        fnorm_tr = sqrt(sum(f * f))

        ! Newton (no backtracking)
        nstats = newton_stats()
        call cpu_time(t_start)
        do k = 1, reps
            u = u0
            nstats = newton_stats()
            call newton_solve(residual_wrapper, jac_wrapper, u, nopts, nstats)
        end do
        call cpu_time(t_end)
        avg_time_nr = (t_end - t_start) / real(reps, dp)
        call residual_wrapper(u, f)
        fnorm_nr = sqrt(sum(f * f))

        ! Newton (with backtracking)
        nstats_bt = newton_stats()
        call cpu_time(t_start)
        do k = 1, reps
            u = u0
            nstats_bt = newton_stats()
            call newton_solve(residual_wrapper, jac_wrapper, u, nopts_bt, nstats_bt)
        end do
        call cpu_time(t_end)
        avg_time_nr_bt = (t_end - t_start) / real(reps, dp)
        call residual_wrapper(u, f)
        fnorm_nr_bt = sqrt(sum(f * f))

        ! Minpack hybrj1 runs
        allocate(x_mp(n), f_mp(n), jac_mp(n, n))
        ldfjac = n
        lwa = (n * (n + 13)) / 2
        allocate(wa(lwa))
        tol_mp = 1.0e-10_wp
        call cpu_time(t_start)
        do k = 1, reps
            x_mp = real(u0, kind = wp)
            mp_nfev = 0
            mp_njac = 0
            call hybrj1(fcn_hybrj_wrapper, n, x_mp, f_mp, jac_mp, ldfjac, tol_mp, info_mp, wa, lwa)
        end do
        call cpu_time(t_end)
        avg_time_mp = (t_end - t_start) / real(reps, dp)
        call p00_fx(prob, n, real(x_mp, kind = dp), f)
        fnorm_mp = sqrt(sum(f * f))

        write (*,'(1x,i4,1x,"|",1x,i4,1x,"|",1x,a8,1x,"|",1x,i4,1x,"|",1x,i6,1x,"|",1x,i6,1x,"|",1x,i7,1x,"|",1x,i4,1x,"|",1x,es10.3,1x,"|",1x,es10.3,1x,"|",1x,a)') &
            prob, n, "TR", stats%retcode, stats%func_evals, stats%jac_evals, stats%lin_solves, 0, avg_time_tr, fnorm_tr, trim(title)
        write (*,'(1x,i4,1x,"|",1x,i4,1x,"|",1x,a8,1x,"|",1x,i4,1x,"|",1x,i6,1x,"|",1x,i6,1x,"|",1x,i7,1x,"|",1x,i4,1x,"|",1x,es10.3,1x,"|",1x,es10.3,1x,"|",1x,a)') &
            prob, n, "NR", nstats%retcode, nstats%func_evals, nstats%jac_evals, nstats%lin_solves, nstats%backtrack_steps, avg_time_nr, fnorm_nr, trim(title)
        write (*,'(1x,i4,1x,"|",1x,i4,1x,"|",1x,a8,1x,"|",1x,i4,1x,"|",1x,i6,1x,"|",1x,i6,1x,"|",1x,i7,1x,"|",1x,i4,1x,"|",1x,es10.3,1x,"|",1x,es10.3,1x,"|",1x,a)') &
            prob, n, "NR_BT", nstats_bt%retcode, nstats_bt%func_evals, nstats_bt%jac_evals, nstats_bt%lin_solves, nstats_bt%backtrack_steps, avg_time_nr_bt, fnorm_nr_bt, trim(title)
        write (*,'(1x,i4,1x,"|",1x,i4,1x,"|",1x,a8,1x,"|",1x,i4,1x,"|",1x,i6,1x,"|",1x,i6,1x,"|",1x,i7,1x,"|",1x,i4,1x,"|",1x,es10.3,1x,"|",1x,es10.3,1x,"|",1x,a)') &
            prob, n, "MP", info_mp, mp_nfev, mp_njac, 0, 0, avg_time_mp, fnorm_mp, trim(title)

        deallocate(u, u0, f, J, x_mp, f_mp, jac_mp, wa)
    end do

contains

    subroutine residual_wrapper(u, f)
        real(dp), intent(in) :: u(:)
        real(dp), intent(out) :: f(:)
        integer :: nloc
        nloc = size(u)
        call p00_fx(prob_current, nloc, u, f)
    end subroutine residual_wrapper

    subroutine jac_wrapper(u, Jout)
        real(dp), intent(in) :: u(:)
        real(dp), intent(out) :: Jout(:, :)
        integer :: nloc
        nloc = size(u)
        call p00_jac(prob_current, nloc, u, Jout)
    end subroutine jac_wrapper

    subroutine fcn_hybrj_wrapper(n, x, fvec, fjac, ldfjac, iflag)
        use iso_fortran_env, only: real64
        integer, intent(in) :: n, ldfjac
        real(wp), intent(in) :: x(n)
        real(wp), intent(inout) :: fvec(n)
        real(wp), intent(inout) :: fjac(ldfjac, n)
        integer, intent(inout) :: iflag
        real(real64), allocatable :: xtmp(:)

        allocate(xtmp(n))
        xtmp = real(x, kind = real64)

        if (iflag == 1) then
            call p00_fx(prob_current, n, xtmp, fvec)
            mp_nfev = mp_nfev + 1
        else if (iflag == 2) then
            call p00_jac(prob_current, n, xtmp, fjac)
            mp_njac = mp_njac + 1
        end if

        deallocate(xtmp)
    end subroutine fcn_hybrj_wrapper

end program run_test_nonlin
