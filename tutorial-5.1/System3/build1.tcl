# 1) Load the PDB file
mol load pdb 3B32.pdb

# 2) Rename "PDB general name" to "CHARMM-specific name"
[atomselect top "resname ILE and name CD1"] set name CD
[atomselect top "resname HIS"             ] set resname HSD
[atomselect top "resname HOH and name O"  ] set name OH2
[atomselect top "resname HOH"             ] set resname TIP3
[atomselect top "resname CA  and name CA" ] set name CAL
[atomselect top "resname CA"              ] set resname CAL

# 3) Shift the center of mass to the origin
# set sel [atomselect top "all"]
# set com [measure center $sel weight mass]
# $sel moveby [vecscale -1.0 $com]

# 4) Output the PDB file of each segment
set sel1 [atomselect top "protein"    ]
set sel2 [atomselect top "water"      ]
set sel3 [atomselect top "resname CAL"]
$sel1 writepdb proa.pdb
$sel2 writepdb water.pdb
$sel3 writepdb cal.pdb

exit
