#!/bin/bash

spdyn=$GENESIS_BIN_DIR/spdyn

export OMP_NUM_THREADS=4
mpirun -n 8 $spdyn run_prod.inp > run_prod.out
