#!/bin/sh

for i in `seq 16`; do
    cat << EOF > INP2
[INPUT]
psffile         = ../1_setup/wbox.psf
reffile         = ../1_setup/start.pdb
 
[OUTPUT]
comtorfile      = umb_${i}.cv
 
[TRAJECTORY]
trjfile1        = umb_${i}.dcd
md_step1        = 2000
mdout_period1   = 1
ana_period1     = 1
repeat1         = 1

trj_format      = DCD
trj_type        = COOR+BOX
trj_natom       = 0
 
[SELECTION]
group1          = ai:15
group2          = ai:17
group3          = ai:19
group4          = ai:25
group5          = ai:27


[OPTION]
check_only      = NO
allow_backup    = NO
com_torsion1    = 1 2 3 4
com_torsion2    = 2 3 4 5
EOF
    ../bin/trj_analysis INP2
done
