#!/bin/bash


cat << EOF > INP
[INPUT]
reffile = ../1_convert_dcd/rep1.pdb      # PDB file
dcdfile = ../1_convert_dcd/rep{}.dcd     # DCD file
remfile = ../../6_production/rep{}.rem  # REMD parameter ID file
logfile = ../../6_production/rep{}.log  # REMD energy log file
 
[OUTPUT]
pdbfile = par.pdb              # PDB file
trjfile = par{}.dcd            # trajectory file
logfile = par{}.log            # REMD energy log file
 
[SELECTION]
group1         = all             # selection group 1
 
[FITTING]
fitting_method = NO              # NO/TR+ROT/TR/TR+ZROT/XYTR/XYTR+ZROT
 
[OPTION]
convert_type    = PARAMETER      # (REPLICA/PARAMETER)
convert_ids     =                # selected index (empty = all)(example: 1 2 5-10)
num_replicas    = 14             # total number of replicas used in the simulation
nsteps          = 2500000        # nsteps in [DYNAMICS]
exchange_period =    1250        # exchange_period in [REMD]
crdout_period   =      50        # crdout_period in [DYNAMICS]
eneout_period   =      50        # eneout_period in [DYNAMICS]
trjout_format   = DCD            # (PDB/DCD)
trjout_type     = COOR+BOX       # (COOR/COOR+BOX)
trjout_atom     = 1              # atom group
centering       = NO             # shift center of mass (YES requres psf/prmtop/grotop)
pbc_correct     = NO             # (NO/MOLECULE)
EOF

$GENESIS_BIN_DIR/remd_convert ./INP > log

rm ./INP
