#!/bin/bash

export PATH=/path/to/genesis/bin:$PATH

export OMP_NUM_THREADS=8
export QM_NUM_THREADS=8

# 1) Open MPI
#
mpirun -np 2 --map-by node:pe=${QM_NUM_THREADS} atdyn qmmm_grid.inp  > qmmm_grid.out  2>&1

# 2) Intel MPI
#
#mpirun -np 2 -ppn 2 atdyn qmmm_grid.inp  > qmmm_grid.out  2>&1

