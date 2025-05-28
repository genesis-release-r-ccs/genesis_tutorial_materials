#$ -S /bin/bash
#$ -cwd
#$ -pe ompi 24
#$ -V
#$ -q all.q

mpirun -np 8 -x OMP_NUM_THREADS=3 ../bin/atdyn INPMODELID > logMODELID
