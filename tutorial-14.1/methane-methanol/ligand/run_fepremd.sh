#!/bin/bash

export OMP_NUM_THREADS=4
spdyn=$GENESIS_BIN_DIR/spdyn

# FEP/lambda-REMD
mpirun -machinefile $TMP/machines -npernode 8 -n 96 $spdyn run_fep1.inp > output/run_fep1.out
mpirun -machinefile $TMP/machines -npernode 8 -n 96 $spdyn run_fep2.inp > output/run_fep2.out
