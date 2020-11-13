module def_variables
  implicit none
  real(4) :: start, finish
  real(8) :: pi=3.141592653589793238462643d0, time, dt, k, g, E_int, E_ho, E_kin
  real(8), allocatable :: r(:,:), v(:,:), F(:,:)
  integer ::  N_particles, N_intermeasure, N_measures
  character(100) :: folder, project_name, directory; character(8) :: date ; character(10) :: hour
  logical :: restart_simulation
contains
end module
