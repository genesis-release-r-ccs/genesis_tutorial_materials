#!/bin/bash
#$ -cwd
#$ -V
#$ -q queue
#$ -pe ompi 128
#$ -S /bin/bash

. ../../1_setup/setpath.sh
export OMP_NUM_THREADS=${threads}

mpirun -np 32 -ppn 8  ${program_sp} INP > log
