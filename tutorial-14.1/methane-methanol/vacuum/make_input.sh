#!/bin/sh

# set md type (remd or distributed)
md_type=remd
#md_type=distributed

# set force fields for simulations
topfile="../../toppar/top_all36_prot.rtf, ../../toppar/top_all36_cgenff.rtf" 
parfile="../../toppar/par_all36m_prot.prm, ../../toppar/par_all36_cgenff.prm"  
strfile="../../toppar/toppar_water_ions.str" 


# set parameters of simulations
nrun=2
nrep=12
nsteps=500000 
exchange_period=1000 
fepout_period=500 
eneout_period=500 
crdout_period=5000 
rstout_period=5000 
temperature=300


# set perturbed region
singleA="ai:1-4 and segid:L0"
singleB="ai:6-9 and segid:L1"
dualA="ai:5-5 and segid:L0"
dualB="ai:10-11 and segid:L1"


# FEP-REMD
if [ $md_type = remd ]; then


for j in `seq 1 ${nrun}`; do

if [ $j = 1 ]; then

rstfile="output/run_eq3.rst"

else
k=$((j-1))
rstfile="output/run${k}_rep{}.rst"
fi

cat << EOF > run_fep${j}.inp
[INPUT]
topfile = ${topfile}
parfile = ${parfile}
strfile = ${strfile}


psffile = vacuum.psf
pdbfile = vacuum.pdb

rstfile = ${rstfile}

[OUTPUT]
dcdfile = output/run${j}_rep{}.dcd
rstfile = output/run${j}_rep{}.rst
fepfile = output/run${j}_rep{}.fepout
logfile = output/run${j}_rep{}.log
remfile = output/run${j}_rep{}.rem

[REMD]
dimension       = 1
exchange_period = ${exchange_period}
type1           = alchemy
nreplica1       = ${nrep}

[ALCHEMY]
fep_direction = BothSides
fep_topology  = hybrid
singleA       = 1
singleB       = 2
dualA         = 3
dualB         = 4
fepout_period = ${fepout_period}
equilsteps    = 0
sc_alpha      = 5.0
sc_beta       = 5.0
lambljA       = 1.0  0.909 0.818 0.727 0.636 0.545 0.455 0.364 0.273 0.182 0.091 0.0 
lambljB       = 0.0  0.091 0.182 0.273 0.364 0.455 0.545 0.636 0.727 0.818 0.909 1.0 
lambelA       = 1.0  0.909 0.818 0.727 0.636 0.545 0.455 0.364 0.273 0.182 0.091 0.0 
lambelB       = 0.0  0.091 0.182 0.273 0.364 0.455 0.545 0.636 0.727 0.818 0.909 1.0 
lambbondA     = 1.0  0.909 0.818 0.727 0.636 0.545 0.455 0.364 0.273 0.182 0.091 0.0 
lambbondB     = 0.0  0.091 0.182 0.273 0.364 0.455 0.545 0.636 0.727 0.818 0.909 1.0 
lambrest      = 1.0  1.0   1.0   1.0   1.0   1.0   1.0   1.0   1.0   1.0   1.0   1.0


[ENERGY]
forcefield       = CHARMM
electrostatic    = CUTOFF 
switchdist       = 298.0 
cutoffdist       = 300.0 
pairlistdist     = 305.0 
vdw_force_switch = YES
vacuum           = YES

[DYNAMICS]
integrator        = VVER 

nsteps            = ${nsteps}

timestep          = 0.002 

eneout_period     = ${eneout_period}
crdout_period     = ${crdout_period}
rstout_period     = ${crdout_period}


[CONSTRAINTS]
rigid_bond = YES

[ENSEMBLE]
ensemble    = NVT 

temperature = ${temperature}

tpcontrol   = BUSSI

[BOUNDARY]
type = PBC


[SELECTION]
group1 = ${singleA}
group2 = ${singleB}
group3 = ${dualA}
group4 = ${dualB}
EOF

done

# Distributed compuation for FEP
elif [ $md_type = distributed ]; then

for l in `seq 1 ${nrep}`; do

for j in `seq 1 ${nrun}`; do

if [ $j = 1 ]; then

rstfile="output/run_eq3.rst"

else
k=$((j-1))
rstfile="output/run${k}_rep${l}.rst"
fi

cat << EOF > run${j}_rep${l}.inp
[INPUT]
topfile = ${topfile}
parfile = ${parfile}
strfile = ${strfile}


psffile = vacuum.psf
pdbfile = vacuum.pdb

rstfile = ${rstfile}

[OUTPUT]
dcdfile = output/run${j}_rep${l}.dcd
rstfile = output/run${j}_rep${l}.rst
fepfile = output/run${j}_rep${l}.fepout

[ALCHEMY]
fep_direction = BothSides
fep_topology  = hybrid
fep_md_type   = Single
ref_lambid    = ${l}
singleA       = 1
singleB       = 2
dualA         = 3
dualB         = 4
fepout_period = ${fepout_period}
equilsteps    = 0
sc_alpha      = 5.0
sc_beta       = 5.0
lambljA       = 1.0  0.909 0.818 0.727 0.636 0.545 0.455 0.364 0.273 0.182 0.091 0.0 
lambljB       = 0.0  0.091 0.182 0.273 0.364 0.455 0.545 0.636 0.727 0.818 0.909 1.0 
lambelA       = 1.0  0.909 0.818 0.727 0.636 0.545 0.455 0.364 0.273 0.182 0.091 0.0 
lambelB       = 0.0  0.091 0.182 0.273 0.364 0.455 0.545 0.636 0.727 0.818 0.909 1.0 
lambbondA     = 1.0  0.909 0.818 0.727 0.636 0.545 0.455 0.364 0.273 0.182 0.091 0.0 
lambbondB     = 0.0  0.091 0.182 0.273 0.364 0.455 0.545 0.636 0.727 0.818 0.909 1.0 
lambrest      = 1.0  1.0   1.0   1.0   1.0   1.0   1.0   1.0   1.0   1.0   1.0   1.0


[ENERGY]
forcefield       = CHARMM
electrostatic    = CUTOFF 
switchdist       = 298.0 
cutoffdist       = 300.0 
pairlistdist     = 305.0 
vdw_force_switch = YES
vacuum           = YES

[DYNAMICS]
integrator        = VVER 

nsteps            = ${nsteps}

timestep          = 0.002 

eneout_period     = ${eneout_period}
crdout_period     = ${crdout_period}
rstout_period     = ${crdout_period}

 
[CONSTRAINTS]
rigid_bond = YES

[ENSEMBLE]
ensemble    = NVT 

temperature = ${temperature}

tpcontrol   = BUSSI

[BOUNDARY]
type = PBC

[SELECTION]
group1 = ${singleA}
group2 = ${singleB}
group3 = ${dualA}
group4 = ${dualB}
EOF

done

done


fi
