# Load the PDB file
mol load pdb 3LNQ.pdb

# Rename "PDB general name" to "CHARMM-specific name"
[atomselect top "resname ILE and name CD1"          ] set name CD
[atomselect top "resname HIS"                       ] set resname HSD
[atomselect top "resname DT  and name C7"           ] set name C5M
[atomselect top "nucleic and name OP1"              ] set name O1P
[atomselect top "nucleic and name OP2"              ] set name O2P
[atomselect top "resname DA"                        ] set resname ADE
[atomselect top "resname DT"                        ] set resname THY
[atomselect top "resname DC"                        ] set resname CYT
[atomselect top "resname DG"                        ] set resname GUA

# Shift the center of mass to the origin
# set sel [atomselect top "all"]
# set com [measure center $sel weight mass]
# $sel moveby [vecscale -1.0 $com]

# 4) Output the PDB file of each segment
set sel1 [atomselect top "chain A and protein"]
set sel2 [atomselect top "chain B and nucleic"]
set sel3 [atomselect top "chain C and nucleic"]
$sel1 writepdb proa.pdb
$sel2 writepdb dna1.pdb
$sel3 writepdb dna2.pdb

exit
