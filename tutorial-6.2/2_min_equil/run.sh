#!/bin/bash

spdyn=$GENESIS_BIN_DIR/spdyn

export OMP_NUM_THREADS=4
mpirun -n 8 $spdyn run_min.inp > run_min.out
mpirun -n 8 $spdyn run_eq1.inp > run_eq1.out
mpirun -n 8 $spdyn run_eq2.inp > run_eq2.out
mpirun -n 8 $spdyn run_eq3.inp > run_eq3.out
mpirun -n 8 $spdyn run_eq4.inp > run_eq4.out
mpirun -n 8 $spdyn run_eq5.inp > run_eq5.out
mpirun -n 8 $spdyn run_eq6.inp > run_eq6.out
mpirun -n 8 $spdyn run_eq7.inp > run_eq7.out
