#!/bin/bash

export OMP_NUM_THREADS=4
mpirun -n 112 $GENESIS_BIN_DIR/spdyn run.inp > run.out
