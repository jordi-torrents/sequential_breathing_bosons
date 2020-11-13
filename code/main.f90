program levy_program
  use def_variables
  use various
  use read_input
  integer :: i, printed_points, j
  real(8) :: percent_done
  call cpu_time(start)
  call date_and_time(date,hour)

  g = 0.5d0
  k = (2.d0*dacos(-1.d0))**2

  call open_and_read_input()

  call mesure_energies()
  ! g=E_ho/E_int
  r = r*(E_int/E_ho)**(0.25d0)
  call mesure_energies()


  write(*,'(A52)') '|__________________________________________________|'
  write(*,'(A)', advance='no') ' '
  do i=1,N_measures
    do j=1,int(dble(50*i-1)/dble(N_measures)-dble(printed_points))+1
      write(*,'(A1)', advance='no') '#'
      printed_points = printed_points+1
    enddo

    call save_state()
    ! call Velocity_Verlet_steps(N_intermeasure)
    ! call Position_Verlet_steps(N_intermeasure)
    ! call Position_Forest_Ruth_steps(N_intermeasure)
    call PEFRL_steps(N_intermeasure)
  end do
  call save_state()
  write(*,*) '   Done!'

  call cpu_time(finish)
  print*, 'Time: ', finish-start
end program levy_program
