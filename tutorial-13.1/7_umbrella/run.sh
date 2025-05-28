#!/bin/sh

export OMP_NUM_THREADS=1

# Umbrella sampling
mpirun -np 8 ../bin/spdyn INP > log

# Generate the CV files
./dih.sh
