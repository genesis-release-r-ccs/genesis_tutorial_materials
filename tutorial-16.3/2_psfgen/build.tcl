# Step1 
mol load pdb ./tmp/conv.pdb
[atomselect top "resname HIS"            ] set resname HSD
[atomselect top "name H"                 ] set name HN
[atomselect top "name HG and resname SER"] set name HG1
set sel [atomselect top "all"]
$sel writepdb ./tmp/conv2.pdb

# Step 2
package require psfgen
resetpsf
topology ../Parameters/toppar/top_all36_prot.rtf
segment PROA {pdb ./tmp/conv2.pdb} 
coordpdb ./tmp/conv2.pdb
guesscoord
writepdb model.pdb
writepsf model.psf
exit
