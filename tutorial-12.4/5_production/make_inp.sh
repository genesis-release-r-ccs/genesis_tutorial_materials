#!/bin/bash

for i in {1..10}; do

iseed_line="iseed = `echo $RANDOM`"

cat << EOF > run${i}.inp
[INPUT]
topfile = ../toppar/top_all36_prot.rtf     # topology file
parfile = ../toppar/par_all36m_prot.prm    # parameter file
strfile = ../toppar/toppar_water_ions.str  # stream file
psffile = ../1_setup/wbox.psf              # protein structure file
pdbfile = ../1_setup/wbox.pdb              # PDB file
rstfile = ../4_update_parameter/run.rst    # restart file
  
[OUTPUT]
dcdfile  = run${i}.dcd
rstfile  = run${i}.rst
gamdfile = run${i}.gamd

[GAMD]
gamd          = yes
boost         = yes
boost_type    = DUAL
thresh_type   = LOWER
sigma0_pot    = 6.0
sigma0_dih    = 1.0
update_period = 0
pot_max       = -37468.2812
pot_min       = -38756.9062
pot_ave       = -37715.0977
pot_dev       = 80.5305
dih_max       = 23.1753
dih_min       = -3.0486
dih_ave       = 11.8922
dih_dev       = 2.3506

[ENERGY]
forcefield        = CHARMM   # [CHARMM,AAGO,CAGO,KBGO,AMBER,GROAMBER,GROMARTINI]
electrostatic     = PME      # [CUTOFF,PME]
switchdist        = 10.0     # switch distance
cutoffdist        = 12.0     # cutoff distance
pairlistdist      = 13.5     # pair-list distance
vdw_force_switch  = YES      # force switch option for van der Waals

[DYNAMICS]
integrator        =    VVER
nsteps            = 2500000
timestep          =   0.004
eneout_period     =      25
crdout_period     =      25
rstout_period     =   25000
nbupdate_period   =       5
thermostat_period =       5
barostat_period   =       5
hydrogen_mr       =     yes
hmr_target        =  Solute
hmr_ratio         =     2.5
hmr_ratio_xh1     =     2.0
${iseed_line}
    
[CONSTRAINTS]
rigid_bond        = YES      # constraints all bonds involving hydrogen

[ENSEMBLE]
ensemble          = NVT      # [NVE,NVT,NPT,NPAT,NPgT]
tpcontrol         = BUSSI    # [NO,BERENDSEN,BUSSI,LANGEVIN]
temperature       = 300      # initial and target temperature (K)
group_tp          = YES      # usage of group tempeature and pressure

[BOUNDARY]
type              = PBC      # [PBC, NOBC]
EOF

done
