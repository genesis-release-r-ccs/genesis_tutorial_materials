#!/bin/bash

rm output.fene output.pmf output*.weight

cat << EOF > INP
[INPUT]
cvfile     = ../3_calc_dist/cv{}.dat  # Collective variable file
 
[OUTPUT]
fenefile   = output.fene      # free energy file
pmffile    = output.pmf       # potential of mean force file
weightfile = output{}.weight  # weight file
 
[MBAR]
nreplica           = 14
input_type         = CV
dimension          = 1
nblocks            = 1
temperature        = 300.0
target_temperature = 300.0
rest_function1     = 1
grids1             = 0.0 14.0 141
output_unit        = kcal/mol
 
[RESTRAINTS]
constant1          =  1.2  1.2  1.2  1.2  1.2  1.2  1.2  1.2  1.2   1.2   1.2   1.2   1.2   1.2
reference1         = 1.80 2.72 3.64 4.56 5.48 6.40 7.32 8.24 9.16 10.08 11.00 11.92 12.84 13.76
is_periodic1       = NO
EOF

$GENESIS_BIN_DIR/mbar_analysis ./INP

rm ./INP
