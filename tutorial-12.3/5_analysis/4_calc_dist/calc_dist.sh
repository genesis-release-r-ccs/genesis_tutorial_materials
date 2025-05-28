#!/bin/bash

for i in 1 2 3 4; do

cat << EOF > inp${i}
[INPUT]
reffile        = ../3_sort/param.pdb
 
[OUTPUT]
disfile        = param${i}.dis
 
[TRAJECTORY]
trjfile1       = ../3_sort/param${i}.dcd
md_step1       = 3000000         # number of MD steps
mdout_period1  = 300             # MD output period
ana_period1    = 300             # analysis period
repeat1        = 1
trj_format     = DCD             # (PDB/DCD)
trj_type       = COOR+BOX        # (COOR/COOR+BOX)
trj_natom      = 0               # (0:uses reference PDB atom count)
 
[OPTION]
check_only     = NO              # (YES/NO)
distance1      = PROA:1:ALA:OY PROA:3:ALA:HNT
EOF

trj_analysis ./inp${i}

rm ./inp${i}

done
