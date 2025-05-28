#! /bin/bash -f
#$ -S /bin/bash
#$ -cwd
#$ -V
#$ -pe ompi28 28
#$ -q queue
#$ -N single

export OMP_NUM_THREADS=3
nmpi=8
npernode=8
. ./setpath.sh
name=DoME_single
$mpicommand ${program_atdyn} ${name}.inp >${name}.log 2>&1
