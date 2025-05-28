! DCD analysis program
!
program main

  implicit none
  integer              :: i, natom
  integer(4)           :: dcdinfo(20), ntitle
  real(4), allocatable :: coord(:,:)
  real(8)              :: boxsize(1:6)
  character(len=4)     :: header
  character(len=80)    :: title(10)

  open(10, file='run.dcd', form='unformatted', status='old')
  read(10) header, dcdinfo(1:20)
  read(10) ntitle, (title(i),i=1,ntitle)
  read(10) natom

  allocate(coord(1:3,1:natom))

  do i = 1, dcdinfo(1)
    read(10) boxsize(1:6)
    read(10) coord(1,1:natom)
    read(10) coord(2,1:natom)
    read(10) coord(3,1:natom)

    ! Analyze the snapshot here

  end do
  close(10)

end program main
