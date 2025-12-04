program run_test_nonlin
    use iso_fortran_env, only: real64
    use trust_region_nls
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
    real(dp) :: t_start, t_end, fnorm_tr, fnorm_mp
    real(dp) :: avg_time_tr, avg_time_mp
    ! Minpack workspace
    real(wp), allocatable :: x_mp(:), f_mp(:), jac_mp(:, :), wa(:)
    real(wp) :: tol_mp
    integer :: info_mp, lwa, ldfjac
    integer :: mp_nfev, mp_njac
    integer :: prob_current

    opts%abs_tol = 1.0e-10_dp
    opts%rel_tol = 1.0e-10_dp
    opts%max_iters = 200

    write (*,'(1x,a7,1x,"|",1x,a3,1x,"|",1x,a6,1x,"|",1x,a6,1x,"|",1x,a6,1x,"|",1x,a7,1x,"|",1x,a11,1x,"|",1x,a11,1x,"|",1x,a6,1x,"|",1x,a6,1x,"|",1x,a6,1x,"|",1x,a11,1x,"|",1x,a11)') &
        "problem", "n", "TR_ret", "TR_nf", "TR_njac", "TR_nsolve", "TR_time(s)", "TR||f||", "MP_ret", "MP_nf", "MP_njac", "MP_time(s)", "MP||f||"
    print *, "------------------------------------------------------------------------------------------------------------------------------------------"

    do prob = 1, nprob
        prob_current = prob
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

        write (*,'(1x,i7,1x,"|",1x,i3,1x,"|",1x,i6,1x,"|",1x,i6,1x,"|",1x,i6,1x,"|",1x,i7,1x,"|",1x,es11.4,1x,"|",1x,es11.4,1x,"|",1x,i6,1x,"|",1x,i6,1x,"|",1x,i6,1x,"|",1x,es11.4,1x,"|",1x,es11.4)') &
            prob, n, stats%retcode, stats%func_evals, stats%jac_evals, stats%lin_solves, avg_time_tr, fnorm_tr, &
            info_mp, mp_nfev, mp_njac, avg_time_mp, fnorm_mp

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
