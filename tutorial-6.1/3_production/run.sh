#!/bin/bash

spdyn=../../../Programs/genesis-2.0/bin/spdyn

# 1000ps MD in the NPT ensemble using VRES
export OMP_NUM_THREADS=1
mpirun -np 16 $spdyn step7_production.inp >& log7
