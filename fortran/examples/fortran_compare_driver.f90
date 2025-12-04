program fortran_compare_driver

!*****************************************************************************80
!
!! Driver to emit reference outputs from test_nonlin.f90 for comparison.
!
  implicit none

  integer, parameter :: rk = kind ( 1.0D+00 )

  integer i
  integer j
  integer n
  integer nval
  integer problem

  real ( kind = rk ), allocatable :: fjac(:,:)
  real ( kind = rk ), allocatable :: f(:)
  real ( kind = rk ), allocatable :: x(:)

  character ( len = 120 ) title

  do problem = 1, 23

    call p00_n ( problem, nval )
    n = abs ( nval )

    allocate ( x(n) )
    allocate ( f(n) )
    allocate ( fjac(n,n) )

    call p00_start ( problem, n, x )
    call p00_fx ( problem, n, x, f )
    call p00_jac ( problem, n, x, fjac )
    call p00_title ( problem, title )

    write ( *, '( "P:", I0 )' ) problem
    write ( *, '( "TITLE:", A )' ) trim ( title )
    write ( *, '( "N:", I0 )' ) n

    write ( *, '( "X:", *( ES24.16E3, 1X ) )' ) x(1:n)
    write ( *, '( "F:", *( ES24.16E3, 1X ) )' ) f(1:n)

    do i = 1, n
      write ( *, '( "J:", *( ES24.16E3, 1X ) )' ) fjac(i,1:n)
    end do

    deallocate ( x )
    deallocate ( f )
    deallocate ( fjac )

  end do

end program fortran_compare_driver
