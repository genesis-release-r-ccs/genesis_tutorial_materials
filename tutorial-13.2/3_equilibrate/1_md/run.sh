#!/bin/bash
#$ -cwd
#$ -V
#$ -q queue
#$ -pe ompi 32
#$ -S /bin/bash

. ../../1_setup/setpath.sh
export OMP_NUM_THREADS=${threads}

mpirun -ppn 8 -np 8 ${program_sp} INP1 > log1
mpirun -ppn 8 -np 8 ${program_sp} INP2 > log2
mpirun -ppn 8 -np 8 ${program_sp} INP3 > log3
