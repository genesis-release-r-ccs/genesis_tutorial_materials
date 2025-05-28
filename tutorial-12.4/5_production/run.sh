#!/bin/bash

GENESIS_BIN_DIR=../../../GENESIS_Tutorials-2022/Programs/genesis-2.0/bin/

mpirun -n 8 $GENESIS_BIN_DIR/spdyn run1.inp > run1.out
mpirun -n 8 $GENESIS_BIN_DIR/spdyn run2.inp > run2.out
mpirun -n 8 $GENESIS_BIN_DIR/spdyn run3.inp > run3.out
mpirun -n 8 $GENESIS_BIN_DIR/spdyn run4.inp > run4.out
mpirun -n 8 $GENESIS_BIN_DIR/spdyn run5.inp > run5.out
mpirun -n 8 $GENESIS_BIN_DIR/spdyn run6.inp > run6.out
mpirun -n 8 $GENESIS_BIN_DIR/spdyn run7.inp > run7.out
mpirun -n 8 $GENESIS_BIN_DIR/spdyn run8.inp > run8.out
mpirun -n 8 $GENESIS_BIN_DIR/spdyn run9.inp > run9.out
mpirun -n 8 $GENESIS_BIN_DIR/spdyn run10.inp > run10.out
