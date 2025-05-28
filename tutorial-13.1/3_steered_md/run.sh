#!/bin/sh

export OMP_NUM_THREADS=1

# Run steered MD
mpirun -np 8 ../bin/spdyn INP1 > log1

# Calculate phi and psi
../bin/trj_analysis INP2 > log2

