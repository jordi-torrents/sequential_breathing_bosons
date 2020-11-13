module read_input
  use def_variables
contains
  subroutine open_and_read_input()
    character(24) :: fName, fName2, junk
    character(100):: initial_state_filename
    integer :: fStat, io, un_input=834
    call get_command_argument(1,fName, status=fStat)
    if (fStat /= 0) then
      print*,'Failed at reading input file. Exitting program...'
      call exit()
    end if

    open(unit=un_input,file=trim(fName), status='old')
    read(un_input,*) initial_state_filename
    read(un_input,*) project_name
    read(un_input,*) dt
    read(un_input,*) N_intermeasure
    read(un_input,*) N_measures
    read(un_input,*) restart_simulation
    close(un_input)

    directory = trim(project_name)//'/'//initial_state_filename(:INDEX(initial_state_filename, '.')-1)

    if (restart_simulation) then
      call system('mkdir -p '//trim(project_name))
      call system('mkdir -p '//trim(directory))
      call system('mkdir -p '//trim(directory)//'/advanced_states')
      call system('mkdir -p '//trim(directory)//'/instant_positions')
      open(unit=123, file='initial_states/'//trim(initial_state_filename), status='OLD', action='READ')
      N_particles = 0
      do
        read(123,*,iostat=io)
        if (io/=0) exit
        N_particles = N_particles + 1
      end do
      close(123)
      allocate(r(N_particles,2))
      allocate(v(N_particles,2))
      allocate(F(N_particles,2))
      open(unit=123, file='initial_states/'//trim(initial_state_filename), status='OLD', action='READ')
      do i=1,N_particles
        read(123,*) r(i,1), r(i,2)
      end do
      r(:,1)=r(:,1)-sum(r(:,1))/dble(N_particles)
      r(:,2)=r(:,2)-sum(r(:,2))/dble(N_particles)
      v=0.d0
      time=0.d0
      close(123)
    else
      call system('ls -v '//trim(directory)//'/advanced_states/ > files.tmp')

      open(123, file='files.tmp')
      do
        read(123,*,iostat=io) fName2
        if (io/=0) exit
        fName=fName2
      end do

      open(unit=123, file=trim(directory)//'/advanced_states/'//trim(fName), status='OLD', action='READ')
      N_particles = 0
      read(123,*)
      do
        read(123,*,iostat=io)
        if (io/=0) exit
        N_particles = N_particles + 1
      end do
      close(123)

      allocate(r(N_particles,2))
      allocate(v(N_particles,2))
      allocate(F(N_particles,2))

      open(unit=123, file=trim(directory)//'/advanced_states/'//trim(fName), status='OLD', action='READ')
      read(123,*) junk, time
      do i=1,N_particles
        read(123,*) r(i,1), r(i,2), v(i,1), v(i,2)
      end do
      close(123)
      call system('rm files.tmp')
    end if

  end subroutine open_and_read_input

  subroutine save_configuration()
    integer :: i
    character(5) :: filename
    write(filename,'(i5.5)') nint(time*1000.d0)
    open(unit=123, file=trim(directory)//'/instant_positions/'//filename//'.dat')

    do i=1,N_particles
      write(123,'(4f14.8)') r(i,1), r(i,2), v(i,1), v(i,2)
    end do
    close(123)
  end subroutine

  subroutine save_state()
    integer :: i
    character(4) :: filename
    call date_and_time(date,hour)
    write(filename,'(i4.4)') nint(time*1000.d0)
    open(unit=123, file=trim(directory)//'/advanced_states/'//filename//'.dat')
    write(123,'(A7,f8.6,A20)') '#time= ',time,' | '//date(7:8)//'/'//date(5:6)//'/'//date(1:4)//' '//hour(1:2)//':'//hour(3:4)
    do i=1,N_particles
      write(123,*) r(i,1), r(i,2), v(i,1), v(i,2)
    end do
    close(123)
  end subroutine

end module read_input
