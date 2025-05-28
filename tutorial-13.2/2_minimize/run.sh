#!/bin/bash
#$ -cwd
#$ -V
#$ -q queue
#$ -pe ompi 32
#$ -S /bin/bash

. ../1_setup/setpath.sh
export OMP_NUM_THREADS=${threads}

mpiexec -ppn 8 -np 8 ${program_sp} INP > log
