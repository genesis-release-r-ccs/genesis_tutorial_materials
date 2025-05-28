#!/bin/bash


for i in {1..14}; do

rm rep${i}.dcd rep${i}.pdb

cat << EOF > INP
[INPUT]
reffile        = ../../1_setup/wbox.pdb
psffile        = ../../1_setup/wbox.psf
 
[OUTPUT]
pdbfile        = rep${i}.pdb
trjfile        = rep${i}.dcd
 
[TRAJECTORY]
trjfile1       = ../../6_production/rep${i}.dcd
md_step1       = 2500000         # number of MD steps
mdout_period1  =      50         # MD output period
ana_period1    =      50         # analysis period
repeat1        =       1
trj_format     = DCD             # (PDB/DCD)
trj_type       = COOR+BOX        # (COOR/COOR+BOX)
trj_natom      = 0               # (0:uses reference PDB atom count)
 
[SELECTION]
group1         = an:N or an:CA or an:C or an:O
group2         = sid:PROA
 
[FITTING]
fitting_method = TR+ROT          # method
fitting_atom   = 1               # atom group
mass_weight    = YES             # mass-weight is applied
 
[OPTION]
check_only     = NO              # (YES/NO)
trjout_format  = DCD             # (PDB/DCD)
trjout_type    = COOR+BOX        # (COOR/COOR+BOX)
trjout_atom    = 2               # atom group
pbc_correct    = NO              # (NO/MOLECULE)
EOF

$GENESIS_BIN_DIR/crd_convert INP > log${i}

rm INP

done
