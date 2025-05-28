#Please write your path of GENESIS
program_ana=/home/${USER}/genesis/bin/
program_atdyn=${program_ana}/atdyn

mpicommand="mpiexec -genv OMP_NUM_THREADS=$OMP_NUM_THREADS -genv I_MPI_FABRICS=shm:ofa  -ppn ${npernode} -np ${nmpi}"
