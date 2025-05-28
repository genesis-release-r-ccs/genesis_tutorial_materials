#!/bin/bash

spdyn=../../../Programs/genesis-2.0/bin/spdyn

# 2000 step energy minimization
# with dihedral angle restraint (k = 250 kcal/mol)
#      z-positional restraint on P atoms (k = 2.5 kcal/mol/Angs^2)
export OMP_NUM_THREADS=1
mpirun -np 16 $spdyn step6.0_minimization.inp >& log6.0

# 25ps MD in the NVT ensemble
# with dihedral angle restraint (k = 250 kcal/mol)
#      z-positional restraint on P atoms (k = 2.5 kcal/mol/Angs^2)
mpirun -np 16 $spdyn step6.1_equilibration.inp >& log6.1

# 25ps MD in the NVT ensemble
# with dihedral angle restraint (k = 100 kcal/mol)
#      z-positional restraint on P atoms (k = 2.5 kcal/mol/Angs^2)
mpirun -np 16 $spdyn step6.2_equilibration.inp >& log6.2

# 25ps MD in the NPT ensemble
# with dihedral angle restraint (k = 50 kcal/mol)
#      z-positional restraint on P atoms (k = 1.0 kcal/mol/Angs^2)
mpirun -np 16 $spdyn step6.3_equilibration.inp >& log6.3

# 100ps MD in the NPT ensemble
# with dihedral angle restraint (k = 50 kcal/mol)
#      z-positional restraint on P atoms (k = 0.5 kcal/mol/Angs^2)
mpirun -np 16 $spdyn step6.4_equilibration.inp >& log6.4

# 100ps MD in the NPT ensemble
# with dihedral angle restraint (k = 25 kcal/mol)
#      z-positional restraint on P atoms (k = 0.1 kcal/mol/Angs^2)
mpirun -np 16 $spdyn step6.5_equilibration.inp >& log6.5

# 100ps MD in the NPT ensemble without any restraints using VRES
mpirun -np 16 $spdyn step6.6_equilibration.inp >& log6.6
