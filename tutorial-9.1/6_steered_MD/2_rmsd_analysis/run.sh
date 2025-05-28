#!/bin/bash
#$ -cwd
#$ -V
#$ -q queue
#$ -pe ompi1 1
#$ -S /bin/bash

. ../../1_setup/setpath.sh
export OMP_NUM_THREADS=1

${program_ana}/rmsd_analysis INP |& tee log
