#!/bin/bash
#$ -cwd
#$ -V
#$ -q q3.q
#$ -pe ompi32 32
#$ -S /bin/bash

. ../../1_setup/setpath.sh
export OMP_NUM_THREADS=4

mpirun -ppn 8 -np 8 ${program_sp} INP > log
