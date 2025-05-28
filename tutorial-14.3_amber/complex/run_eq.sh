#!/bin/bash

export OMP_NUM_THREADS=4
spdyn=$GENESIS_BIN_DIR/spdyn

mpirun -machinefile $TMP/machines -npernode 8 -n 8 $spdyn run_min.inp > output/run_min.out
mpirun -machinefile $TMP/machines -npernode 8 -n 8 $spdyn run_eq1.inp > output/run_eq1.out
mpirun -machinefile $TMP/machines -npernode 8 -n 8 $spdyn run_eq2.inp > output/run_eq2.out
mpirun -machinefile $TMP/machines -npernode 8 -n 8 $spdyn run_eq3.inp > output/run_eq3.out
