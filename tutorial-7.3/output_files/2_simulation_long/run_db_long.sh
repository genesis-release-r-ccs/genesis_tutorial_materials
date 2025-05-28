#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -pe ompi8 8
#$ -q q3.q
#$ -j y


# set the number of OpenMP threads
export OMP_NUM_THREADS=2
pdir=/home/shinobuai/genesis-ver/genesis-1.7.1/bin

ulimit -c 0
mpirun -machinefile $TMP/machines -np 4 -npernode 4 ${pdir}/atdyn run_db_long.inp | tee run_db_long.out

