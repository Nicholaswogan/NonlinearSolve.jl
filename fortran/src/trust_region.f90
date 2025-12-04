module trust_region_nls
    use iso_fortran_env, only: real64
    use, intrinsic :: ieee_arithmetic
    implicit none
    private

    integer, parameter :: dp = real64

    public :: trust_region_opts, trust_region_stats, trust_region_solve

    type :: trust_region_opts
        integer :: max_iters = 100
        integer :: max_shrink_times = 32
        real(dp) :: abs_tol = 1.0e-8_dp
        real(dp) :: rel_tol = 1.0e-8_dp
        real(dp) :: du_abs_tol = 1.0e-10_dp
        real(dp) :: du_rel_tol = 1.0e-10_dp
        real(dp) :: stagnation_tol = 1.0e-12_dp
        integer :: stagnation_iters = 5
        real(dp) :: initial_trust_radius = -1.0_dp
        real(dp) :: max_trust_radius = huge(1.0_dp)
        real(dp) :: step_threshold = 1.0e-4_dp
        real(dp) :: shrink_threshold = 0.05_dp
        real(dp) :: expand_threshold = 0.9_dp
        real(dp) :: shrink_factor = 0.5_dp
        real(dp) :: expand_factor = 2.0_dp
    end type trust_region_opts

    type :: trust_region_stats
        integer :: iters = 0
        integer :: shrink_steps = 0
        integer :: func_evals = 0
        integer :: jac_evals = 0
        integer :: lin_solves = 0
        logical :: converged = .false.
        integer :: retcode = 0
    end type trust_region_stats

    abstract interface
        subroutine residual_fun(u, f)
            import dp
            real(dp), intent(in) :: u(:)
            real(dp), intent(out) :: f(:)
        end subroutine residual_fun

        subroutine jacobian_fun(u, J)
            import dp
            real(dp), intent(in) :: u(:)
            real(dp), intent(out) :: J(:, :)
        end subroutine jacobian_fun
    end interface

    interface
        subroutine dgesv(n, nrhs, a, lda, ipiv, b, ldb, info)
            use iso_fortran_env, only: real64
            integer, intent(in) :: n, nrhs, lda, ldb
            integer, intent(out) :: ipiv(*)
            real(real64), intent(inout) :: a(lda, *)
            real(real64), intent(inout) :: b(ldb, *)
            integer, intent(out) :: info
        end subroutine dgesv
    end interface

contains

    !!> Trust-region Newton solver using the NLsolve-style radius update.
    !!
    !! This routine solves a dense real nonlinear system `f(u, p) = 0` using a dogleg
    !! trust-region step with the NLsolve radius update scheme (shrink on poor ratio,
    !! expand on good ratio). The user must provide a residual and a dense Jacobian.
    !!
    !! **Globalization**: Dogleg step plus trust-region acceptance via ratio
    !! `ρ = (||f(u + δ)||² - ||f(u)||²) / (2*(δᵀJᵀf + 0.5*||Jδ||²))`.
    !!
    !! **Termination** (real-valued): residual norm <= max(abs_tol, rel_tol*(1+||u||)),
    !! step norm <= max(du_abs_tol, du_rel_tol*(1+||u||)) after an accepted step, or
    !! stagnation (residual decrease below `stagnation_tol` for `stagnation_iters`
    !! accepted steps). Max iterations and shrink-threshold exits are also enforced.
    !!
    !! **Retcodes**: 0 success, 1 max iters, 2 linear solve failure, 3 shrink exceeded,
    !! 4 stagnation, 5 non-finite detected.
    !!
    !! @param residual   User residual callback `f(u, f_out)`
    !! @param jacobian   User Jacobian callback `J(u, J_out)`
    !! @param[in,out] u  Initial guess on input; solution estimate on output
    !! @param opts       Solver options (tolerances, trust-region settings)
    !! @param stats      Solver statistics (iterations, eval counts, retcode)
    subroutine trust_region_solve(residual, jacobian, u, opts, stats)
        procedure(residual_fun) :: residual
        procedure(jacobian_fun) :: jacobian
        real(dp), intent(inout) :: u(:)
        type(trust_region_opts), intent(in), optional :: opts
        type(trust_region_stats), intent(inout), optional :: stats

        type(trust_region_opts) :: o
        type(trust_region_stats) :: s

        real(dp), allocatable :: f(:), f_trial(:), g(:), step(:), p_u(:), p_b(:)
        real(dp), allocatable :: J(:, :), J_fact(:, :), rhs(:), Jg(:), Jstep(:)
        real(dp) :: delta, fnorm, fnorm_trial, rho, predicted, numerator
        real(dp) :: step_norm
        integer :: info
        integer :: shrink_counter
        logical :: accept_step
        logical :: recompute_jacobian, tried_recompute
        real(dp) :: step_tol, norm_u
        real(dp) :: last_accepted_fnorm
        integer :: stagnation_count
        integer :: n

        o = trust_region_opts()
        if (present(opts)) o = opts
        s = trust_region_stats()
        if (present(stats)) s = stats

        n = size(u)

        allocate(f(n), f_trial(n), g(n), step(n), p_u(n), p_b(n))
        allocate(J(n, n), J_fact(n, n), rhs(n), Jg(n), Jstep(n))

        call residual(u, f)
        s%func_evals = s%func_evals + 1
        if (.not. is_finite_vec(f)) then
            s%retcode = 5
            goto 200
        end if
        ! Julia counts an initial Jacobian build; mirror that for stats alignment.
        call jacobian(u, J)
        s%jac_evals = s%jac_evals + 1
        fnorm = vec_norm2(f)

        delta = o%initial_trust_radius
        if (delta <= 0.0_dp) delta = max(vec_norm2(u), 1.0_dp)
        delta = min(delta, o%max_trust_radius)

        shrink_counter = 0
        recompute_jacobian = .true.
        stagnation_count = 0
        last_accepted_fnorm = fnorm

        do while (s%iters < o%max_iters)
            norm_u = vec_norm2(u)
            if (fnorm <= max(o%abs_tol, o%rel_tol * (1.0_dp + norm_u))) then
                s%converged = .true.
                s%retcode = 0
                exit
            end if

            if (recompute_jacobian) then
                call jacobian(u, J)
                s%jac_evals = s%jac_evals + 1
                if (.not. is_finite_mat(J)) then
                    s%retcode = 5
                    goto 200
                end if
            end if

            g = matmul(transpose(J), f)
            Jg = matmul(J, g)

            rhs = -f
            J_fact = J
            tried_recompute = .false.
            solve_attempt: do
                call solve_linear_system(n, J_fact, rhs, info)
                s%lin_solves = s%lin_solves + 1
                if (info /= 0) then
                    if (.not. tried_recompute .and. .not. recompute_jacobian) then
                        recompute_jacobian = .true.
                        tried_recompute = .true.
                        call jacobian(u, J)
                        s%jac_evals = s%jac_evals + 1
                        J_fact = J
                        rhs = -f
                        cycle solve_attempt
                    else
                        s%retcode = 2
                        exit solve_attempt
                    end if
                else
                    exit solve_attempt
                end if
            end do solve_attempt

            p_b = rhs
            call dogleg_step(g, Jg, p_b, delta, step)

            step_norm = vec_norm2(step)
            f_trial = f
            call residual(u + step, f_trial)
            s%func_evals = s%func_evals + 1
            if (.not. is_finite_vec(f_trial)) then
                s%retcode = 5
                goto 200
            end if
            fnorm_trial = vec_norm2(f_trial)

            Jstep = matmul(J, step)
            predicted = dot_product(step, g) + 0.5_dp * dot_product(Jstep, Jstep)
            if (abs(predicted) < tiny(predicted)) predicted = sign(tiny(1.0_dp), predicted + tiny(1.0_dp))
            if (.not. ieee_is_finite(predicted)) then
                s%retcode = 5
                goto 200
            end if

            numerator = (fnorm_trial * fnorm_trial - fnorm * fnorm) / 2.0_dp
            rho = numerator / predicted
            if (.not. ieee_is_finite(rho)) then
                s%retcode = 5
                goto 200
            end if

            call update_radius_nlsolve(rho, step_norm, delta, shrink_counter, o)
            accept_step = (rho > o%step_threshold)
            s%shrink_steps = shrink_counter

            if (accept_step) then
                u = u + step
                f = f_trial
                fnorm = fnorm_trial
                recompute_jacobian = .true.

                norm_u = vec_norm2(u)
                step_tol = max(o%du_abs_tol, o%du_rel_tol * (1.0_dp + norm_u))
                if (step_norm <= step_tol .or. fnorm <= max(o%abs_tol, o%rel_tol * (1.0_dp + norm_u))) then
                    s%iters = s%iters + 1
                    s%converged = .true.
                    s%retcode = 0
                    exit
                end if

                if ((last_accepted_fnorm - fnorm) <= o%stagnation_tol * max(1.0_dp, last_accepted_fnorm)) then
                    stagnation_count = stagnation_count + 1
                else
                    stagnation_count = 0
                end if
                last_accepted_fnorm = fnorm

                if (stagnation_count >= o%stagnation_iters) then
                    s%iters = s%iters + 1
                    s%retcode = 4
                    exit
                end if
            end if

            if (shrink_counter > o%max_shrink_times) then
                s%retcode = 3
                exit
            end if

            s%iters = s%iters + 1
            if (.not. accept_step) recompute_jacobian = .false.
        end do

        if (.not. s%converged .and. s%retcode == 0) then
            s%retcode = 1
        end if

200     if (s%retcode == 0 .or. s%converged) then
            s%func_evals = s%func_evals + 1
        end if
        if (present(stats)) stats = s

        deallocate(f, f_trial, g, step, p_u, p_b, J, J_fact, rhs, Jg, Jstep)
    end subroutine trust_region_solve

    subroutine solve_linear_system(n, A, b, info)
        integer, intent(in) :: n
        real(dp), intent(inout) :: A(n, n)
        real(dp), intent(inout) :: b(n)
        integer, intent(out) :: info

        integer :: ipiv(n)

        call dgesv(n, 1, A, n, ipiv, b, n, info)
    end subroutine solve_linear_system

    subroutine dogleg_step(g, Jg, newton_step, delta, step_out)
        real(dp), intent(in) :: g(:)
        real(dp), intent(in) :: Jg(:)
        real(dp), intent(in) :: newton_step(:)
        real(dp), intent(in) :: delta
        real(dp), intent(out) :: step_out(:)

        real(dp) :: g_norm2, Jg_norm2, alpha_sd
        real(dp) :: p_u_norm, p_b_norm, tau, a, b, c, disc
        real(dp), allocatable :: p_u(:), diff(:)

        allocate(p_u(size(g)), diff(size(g)))

        g_norm2 = dot_product(g, g)
        Jg_norm2 = dot_product(Jg, Jg)

        if (g_norm2 <= tiny(1.0_dp)) then
            step_out = 0.0_dp
            deallocate(p_u, diff)
            return
        end if

        alpha_sd = g_norm2 / max(Jg_norm2, tiny(1.0_dp))
        p_u = -alpha_sd * g
        p_u_norm = vec_norm2(p_u)
        p_b_norm = vec_norm2(newton_step)

        if (p_b_norm <= delta) then
            step_out = newton_step
        else if (p_u_norm >= delta) then
            step_out = -(delta / sqrt(g_norm2)) * g
        else
            diff = newton_step - p_u
            a = dot_product(diff, diff)
            b = 2.0_dp * dot_product(p_u, diff)
            c = dot_product(p_u, p_u) - delta * delta
            disc = max(0.0_dp, b * b - 4.0_dp * a * c)
            tau = (-b + sqrt(disc)) / (2.0_dp * a)
            tau = max(0.0_dp, min(1.0_dp, tau))
            step_out = p_u + tau * diff
        end if

        deallocate(p_u, diff)
    end subroutine dogleg_step

    subroutine update_radius_nlsolve(rho, step_norm, delta, shrink_counter, o)
        real(dp), intent(in) :: rho
        real(dp), intent(in) :: step_norm
        real(dp), intent(inout) :: delta
        integer, intent(inout) :: shrink_counter
        type(trust_region_opts), intent(in) :: o

        if (rho < o%shrink_threshold) then
            delta = delta * o%shrink_factor
            shrink_counter = shrink_counter + 1
        else
            shrink_counter = 0
            if (rho >= o%expand_threshold) then
                delta = o%expand_factor * step_norm
            else if (rho >= 0.5_dp) then
                delta = max(delta, o%expand_factor * step_norm)
            end if
        end if

        delta = min(delta, o%max_trust_radius)
    end subroutine update_radius_nlsolve

    pure real(dp) function vec_norm2(x)
        real(dp), intent(in) :: x(:)
        vec_norm2 = sqrt(dot_product(x, x))
    end function vec_norm2

    pure logical function is_finite_vec(x)
        real(dp), intent(in) :: x(:)
        integer :: i
        is_finite_vec = .true.
        do i = 1, size(x)
            if (.not. ieee_is_finite(x(i))) then
                is_finite_vec = .false.
                return
            end if
        end do
    end function is_finite_vec

    pure logical function is_finite_mat(x)
        real(dp), intent(in) :: x(:, :)
        integer :: i, j
        is_finite_mat = .true.
        do j = 1, size(x, 2)
            do i = 1, size(x, 1)
                if (.not. ieee_is_finite(x(i, j))) then
                    is_finite_mat = .false.
                    return
                end if
            end do
        end do
    end function is_finite_mat

end module trust_region_nls
