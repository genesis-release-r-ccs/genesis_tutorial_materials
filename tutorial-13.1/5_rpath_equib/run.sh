#!/bin/sh

export OMP_NUM_THREADS=1

# First equilibration with weak restraint
mpirun -np 8 ../bin/spdyn INP1 > log1

# Second equilibration with strong restraint
mpirun -np 8 ../bin/spdyn INP2 > log2

