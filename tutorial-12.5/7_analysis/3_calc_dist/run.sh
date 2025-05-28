#!/bin/bash


for i in {1..14}; do

rm cv${i}.dat

cat << EOF > INP
[INPUT]
reffile = ../2_sort_dcd/par.pdb              # PDB file

[OUTPUT]
disfile    = cv${i}.dat

[TRAJECTORY]
trjfile1      = ../2_sort_dcd/par${i}.dcd    # DCD file
md_step1      = 2500000                      # number of MD steps
mdout_period1 = 50                           # MD output period
ana_period1   = 50                           # analysis period
repeat1       = 1
trj_format    = DCD                          # (PDB/DCD)
trj_type      = COOR+BOX                     # (COOR/COOR+BOX)

[OPTION]
check_only = NO
distance1  = PROA:1:ALA:OY PROA:3:ALA:HNT
EOF

$GENESIS_BIN_DIR/trj_analysis ./INP > log${i}

rm ./INP

done
