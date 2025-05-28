#!/bin/sh

export OMP_NUM_THREADS=1

# Run minimization
mpirun -np 8 ../bin/spdyn INP1 > log1

# Run first-step NVT equilibration
mpirun -np 8 ../bin/spdyn INP2 > log2

# Run second-step NPT equilibration
mpirun -np 8 ../bin/spdyn INP3 > log3
