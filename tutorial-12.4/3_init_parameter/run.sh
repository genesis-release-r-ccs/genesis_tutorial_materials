#!/bin/bash

GENESIS_BIN_DIR=../../../GENESIS_Tutorials-2022/Programs/genesis-2.0/bin/

mpirun -n 8 $GENESIS_BIN_DIR/spdyn run.inp > run.out
