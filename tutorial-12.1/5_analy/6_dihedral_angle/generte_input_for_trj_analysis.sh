#!/bin/bash

for i in {1..20}; do

cat << EOF > trj_dihedral_parmID${i}.inp
[INPUT]
psffile         = ../../1_setup/proa.psf
reffile         = ../../1_setup/proa.pdb

[OUTPUT]
torfile         = parmID${i}.tor

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
torsion1        = PROA:1:ALA:C   PROA:2:ALA:N    PROA:2:ALA:CA   PROA:2:ALA:C
torsion2        = PROA:2:ALA:N   PROA:2:ALA:CA   PROA:2:ALA:C    PROA:3:ALA:N
EOF

done

