#!/bin/bash

# set md type (remd or distributed)
md_type=remd
#md_type=distributed

# set parameters of simulations
nrun=2
nrep=24 
nsteps=400000 
exchange_period=800 
fepout_period=400 
temperature=300

# clean
rm fene.dat par*.fepout output/run*_par*.fepout

# FEP-REMD
if [ $md_type = remd ]; then
# sort fepout files
for i in `seq 1 $nrun`; do
cat << EOF > INP
[INPUT]
remfile        = ./output/run${i}_rep{}.rem
enefile        = ./output/run${i}_rep{}.fepout
[OUTPUT]
enefile        = ./output/run${i}_par{}.fepout
[OPTION]
check_only      = NO
convert_type    = PARAMETER
convert_ids     = 
num_replicas    = ${nrep}
nsteps          = ${nsteps}
exchange_period = ${exchange_period}
crdout_period   = ${fepout_period}
EOF
$GENESIS_BIN_DIR/remd_convert ./INP
rm ./INP
done

# merge fepout files to one file for each replica
# Trajectories from run2 to run${nrun} are used (i.e. run1 is skipped).
for repid in `seq 1 $nrep`; do
	cp /dev/null par${repid}.fepout
	for runid in `seq 2 $nrun`; do
		cat output/run${runid}_par${repid}.fepout >> par${repid}.fepout
	done
done

# Distributed compuation for FEP
elif [ $md_type = distributed ]; then
# merge fepout files to one file for each replica
# Trajectories from run2 to run${nrun} are used (i.e. run1 is skipped).
for repid in `seq 1 $nrep`; do
	cp /dev/null par${repid}.fepout
	for runid in `seq 2 $nrun`; do
		cat output/run${runid}_rep${repid}.fepout >> par${repid}.fepout
	done
done

fi

# calculate free energies using BAR
cat << EOF > INP
[INPUT]
cvfile    = par{}.fepout
[OUTPUT]
fenefile   = fene.dat
[MBAR]
input_type        = EnePair
dimension         = 1
nblocks           = 3
temperature       = ${temperature}
target_temperature = ${temperature}
tolerance         = 1.0E-08
num_replicas      = ${nrep}
output_unit       = kcal/mol
EOF
$GENESIS_BIN_DIR/mbar_analysis ./INP
rm ./INP

