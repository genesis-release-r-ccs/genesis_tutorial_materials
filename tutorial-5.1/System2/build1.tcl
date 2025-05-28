# 1) Load the PDB file
mol load pdb 6OSW.pdb

# 2) Rename "PDB general name" to "CHARMM-specific name"
[atomselect top "resname ILE and name CD1"] set name CD
[atomselect top "resname HIS"             ] set resname HSD

# 3) Shift the center of mass to the origin
# set sel [atomselect top "all" frame 0]
# set com [measure center $sel weight mass]
# $sel moveby [vecscale -1.0 $com]

# 4) Output the PDB file of each segment
set sel1 [atomselect top "protein and chain A" frame 0]
set sel2 [atomselect top "protein and chain B" frame 0]
$sel1 writepdb proa.pdb
$sel2 writepdb prob.pdb

exit
