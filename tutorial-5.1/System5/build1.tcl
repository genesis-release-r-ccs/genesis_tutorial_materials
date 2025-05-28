# 1) Load the PDB file
mol load pdb 3I40.pdb

# 2) Rename "PDB general name" to "CHARMM-specific name"
[atomselect top "resname ILE and name CD1"] set name CD
[atomselect top "resname HIS"             ] set resname HSD

# 3) Shift the center of mass to the origin
# set sel [atomselect top "all"]
# set com [measure center $sel weight mass]
# $sel moveby [vecscale -1.0 $com]

# 4) Output the PDB file of each segment
set sel1 [atomselect top "(chain A and protein) and not altloc B"]
set sel2 [atomselect top "chain B and protein"]
$sel1 writepdb proa.pdb
$sel2 writepdb prob.pdb

exit
