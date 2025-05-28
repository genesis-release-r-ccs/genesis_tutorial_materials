# Step1 
mol load pdb ./tmp/conv.pdb
[atomselect top "resname HSD"] set resname HIS
set sel [atomselect top "all"]
$sel writepdb ./tmp/conv2.pdb

# Step2
package require psfgen
resetpsf
topology ../Parameters/eef1/toph19_eef1.1.inp
segment PROA {pdb ./tmp/conv2.pdb} 
coordpdb ./tmp/conv2.pdb
guesscoord
writepdb model.pdb
writepsf model.psf
exit
