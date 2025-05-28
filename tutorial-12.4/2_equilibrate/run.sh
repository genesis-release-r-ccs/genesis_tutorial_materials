#!/bin/bash

GENESIS_BIN_DIR=../../../GENESIS_Tutorials-2022/Programs/genesis-2.0/bin/

mpirun -n 8 $GENESIS_BIN_DIR/spdyn run1.inp > run1.out
mpirun -n 8 $GENESIS_BIN_DIR/spdyn run2.inp > run2.out
mpirun -n 8 $GENESIS_BIN_DIR/spdyn run3.inp > run3.out
mpirun -n 8 $GENESIS_BIN_DIR/spdyn run4.inp > run4.out
