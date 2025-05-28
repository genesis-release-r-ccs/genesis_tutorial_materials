program main

  character :: head*13
  character :: an*2
  character :: rnam*7
  integer   :: rno, ir, tmp, ir1, ir2, ir3, ir4, ngrp
  character :: grp*10
  character :: selind*30

  ! count nfunctions
  !
  open(10,file='tmp2',status='old')
  ngrp = 1
  do
    read(10,'(a13,a2,a7,i4)',end=998) head, an, rnam, rno

    if (an == 'O ') then
      tmp = rno
      read(10,'(a13,a2,a7,i4)',end=998) head, an, rnam, rno
      if (rno == tmp + 1) then
        ngrp = ngrp + 1
      end if
    end if
  end do
998 close(10)


  ! make restraint group lists
  !
  open(20,file='selection.dat')
  open(30,file='restraint.dat')

  write(20,*) "[SELECTION]"
  write(20,*) "group1 = an:CA"

  write(30,*) "[RESTRAINTS]"
  write (grp,'(i4)') ngrp
  write(30,*) "nfunctions    = " // trim(grp)
  write(30,*) "function1     = POSI      # restraint function type"
  write(30,*) "direction1    = ALL       # direction [ALL,X,Y,Z]"
  write(30,*) "constant1     = 0.5       # force constant"
  write(30,*) "select_index1 = 1         # restrained groups"
  write(30,*) " "


  open(10,file='tmp2')
  ir   = 1
  ngrp = 1
  do
    read(10,'(a13,a2,a7,i4)',end=999) head, an, rnam, rno

    if (an == 'O ') then

      tmp = rno
      read(10,'(a13,a2,a7,i4)',end=999) head, an, rnam, rno

      if (rno == tmp + 1) then

        ir = ir + 1
        write (grp,'(i4)') ir
        grp = 'group' // adjustl(grp)
        write(20,'(a10,a,i4)') trim(grp), ' = an:O  and resno:', rno-1
        ir1 = ir  

        ir = ir + 1
        write (grp,'(i4)') ir
        grp = 'group' // adjustl(grp)
        write(20,'(a10,a,i4)') trim(grp), ' = an:C  and resno:', rno-1
        ir2 = ir

        ir = ir + 1
        write (grp,'(i4)') ir
        grp = 'group' // adjustl(grp)
        write(20,'(a10,a,i4)') trim(grp), ' = an:N  and resno:', rno
        ir3 = ir

        ir = ir + 1
        write (grp,'(i4)') ir
        grp = 'group' // adjustl(grp)
        write(20,'(a10,a,i4)') trim(grp), ' = an:HN and resno:', rno
        ir4 = ir

        ngrp = ngrp + 1
        write (grp,'(i4)') ngrp

        selind = 'function' // adjustl(grp) // ' = DIHED'
        write(30,'(a30)') selind
        selind = 'constant' // adjustl(grp) // ' = 10 10'
        write(30,'(a30)') selind
        selind = 'reference' // adjustl(grp) // ' = 180 180'
        write(30,'(a30)') selind
        selind = 'select_index' // adjustl(grp) // ' = '
        write(30,'(a30,4i6)') selind, ir1, ir2, ir3, ir4
        write(30,'(a)') '' 

      end if

    end if

  end do
999 close(10)

write(20,'(a)') ''
write(30,'(a)') ''
close(20)
close(30)

end
