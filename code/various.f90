module various
  use def_variables
contains
  subroutine Velocity_Verlet_steps(steps)
    integer :: steps, i
    real(8) :: dt2
    dt2=0.5d0*dt
    call compute_forces(F)

    v = v + F*dt2
    do i=1,steps
      r = r + v*dt
      call compute_forces(F)
      v = v + F*dt
    end do
    v = v - F*dt2
    time = time + dt*dble(steps)
  end subroutine

  subroutine Position_Verlet_steps(steps)
    integer :: steps, i
    real(8) :: dt2
    dt2=0.5d0*dt

    r = r + v*dt2
    do i=1,steps
      call compute_forces(F)
      v = v + F*dt
      r = r + v*dt
    end do
    r = r - v*dt2
    time = time + dt*dble(steps)
  end subroutine

  subroutine Position_Forest_Ruth_steps(steps) ! same as Yoshida algorithm
    integer :: steps, i
    real(8) :: dt2, theta
    theta=1.3512071919596578d0
    dt2=0.5d0*dt

    r=r+theta*dt2*v
    do i=1,steps
      call compute_forces(F)
      v=v+theta*dt*F
      r=r+(1.d0-theta)*dt2*v
      call compute_forces(F)
      v=v+(1.d0-2.d0*theta)*dt*F
      r=r+(1.d0-theta)*dt2*v
      call compute_forces(F)
      v=v+theta*dt*F
      r=r+theta*dt*v
    end do
    r=r-theta*dt2*v

    time = time + dt*dble(steps)
  end subroutine

  subroutine PEFRL_steps(steps)
    integer :: steps, i
    real(8) :: xi, lam, ji
    xi  = 0.1786178958448091d0
    lam =-0.2123418310626054d0
    ji  =-0.6626458266981849d-1

    r=r+v*xi*dt
    do i=1,steps
      call compute_forces(F)
      v=v+(0.5d0-lam)*dt*F
      r=r+ji*dt*v
      call compute_forces(F)
      v=v+lam*dt*F
      r=r+(1.d0-2.d0*(ji+xi))*dt*v
      call compute_forces(F)
      v=v+lam*dt*F
      r=r+ji*dt*v
      call compute_forces(F)
      v=v+F*(0.5d0-lam)*dt
      r=r+2.d0*xi*v*dt
    end do
    r=r-v*xi*dt

    time = time + dt*dble(steps)
  end subroutine

  subroutine compute_forces(F_array)
    integer :: i, j
    real(8) :: F_array(N_particles,2), dif(2), force_ij(2), d2
    F_array=0.d0
    do i=1,N_particles
      F_array(i,:)=F_array(i,:)-k*r(i,:)
      do j=i+1,N_particles
        dif = r(j,:) - r(i,:)
        d2=dif(1)*dif(1)+dif(2)*dif(2)
        ! force_ij = -2.d0*g*dif/(d2*d2)
        force_ij = -dif/(d2*d2)
        F_array(i,:)=F_array(i,:)+force_ij
        F_array(j,:)=F_array(j,:)-force_ij
      end do
    end do
  end subroutine

  subroutine mesure_energies()
    integer :: i, j
    real(8) :: dif(2)
    E_int=0.d0
    E_ho=0.d0
    do i=1,N_particles
      E_ho=E_ho+0.5d0*k*(r(i,1)*r(i,1) + r(i,2)*r(i,2))
      do j=i+1,N_particles
        dif = r(j,:) - r(i,:)
        E_int=E_int+g/(dif(1)*dif(1)+dif(2)*dif(2))
      end do
    end do
    E_int=E_int/dble(N_particles)
    E_ho=E_ho/dble(N_particles)
    E_kin=0.5d0*sum(v*v)/dble(N_particles)
  end subroutine

  ! subroutine forces_th(r, F, n, k, g, th)
  !   integer :: n
  !   real(8), dimension(n,2) :: r, F
  !   real(8), dimension(2)   :: dif, force_ij
  !   real(8) :: k, g, d2, th, th2
  !   th2 = th*th
  !   F=0.d0
  !   do i=1,n
  !     F(i,:)=F(i,:)-k*r(i,:)
  !     do j=i+1,n
  !       dif = r(j,:) - r(i,:)
  !       d2=dif(1)*dif(1)+dif(2)*dif(2)
  !       if (d2<th2) then
  !         force_ij = -2.d0*g*dif/(d2*d2)
  !         F(i,:)=F(i,:)+force_ij
  !         F(j,:)=F(j,:)-force_ij
  !       end if
  !     end do
  !   end do
  ! end subroutine
  !
  ! subroutine mesure_th(r, v, n, k, g, E_int, E_ho, E_kin, th)
  !   integer :: n, i, j
  !   real(8), dimension(n,2) :: r, v
  !   real(8) :: E_int, E_ho, E_kin, k, g, th, d2, E_cut
  !   real(8), dimension(2) :: dif
  !   !f2py intent(out) E_int, E_ho, E_kin
  !   E_cut = g/(th*th)
  !   E_int=0.d0
  !   E_ho=0.d0
  !   do i=1,n
  !     E_ho=E_ho+0.5d0*k*(r(i,1)*r(i,1) + r(i,2)*r(i,2))
  !     do j=i+1,n
  !       dif = r(j,:) - r(i,:)
  !       d2 = dif(1)*dif(1)+dif(2)*dif(2)
  !       if (d2<(th**2)) then
  !         E_int=E_int+g/d2-E_cut
  !       end if
  !     end do
  !   end do
  !   E_int=E_int/dble(n)
  !   E_ho=E_ho/dble(n)
  !   E_kin=0.5d0*sum(v*v)/dble(n)
  ! end subroutine

end module
