#!/bin/sh

export OMP_NUM_THREADS=1

# String simulation
mpirun -np 8 ../bin/spdyn INP > log

# Generate the final minim free energy pathway
if [ -f "last.path" ]; then
    rm "last.path"
fi

for ki in `seq 16`; do
    tail -n 1 rp_${ki}.rpath >> last.path
done
