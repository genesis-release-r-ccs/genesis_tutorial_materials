#!/bin/bash

for i in {1..20}; do

cat << EOF > trj_end_to_end_parmID${i}.inp
[INPUT]
psffile         = ../../1_setup/proa.psf
reffile         = ../../1_setup/proa.pdb

[OUTPUT]
disfile         = parmID${i}.dis

[TRAJECTORY]
trjfile1        = ../3_sort/parmID${i}.dcd
md_step1        = 4000000
mdout_period1   = 2000
ana_period1     = 2000
repeat1         = 1
trj_format      = DCD             # (PDB/DCD)
trj_type        = COOR+BOX        # (COOR/COOR+BOX)
trj_natom       = 0               # (0:uses reference PDB atom count)

[OPTION]
check_only      = NO
distance1       = PROA:1:ALA:OY PROA:3:ALA:HNT
EOF

done

