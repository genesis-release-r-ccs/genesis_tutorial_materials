# Step1 
mol load pdb 4ryo.pdb
set sel [atomselect top "protein"]
$sel writepdb tmp.pdb

# Step 2
package require psfgen
resetpsf
topology ../eef1/toph19_eef1.1.inp
segment PROA {pdb tmp.pdb} 
coordpdb tmp.pdb PROA
guesscoord
writepdb proa.pdb
writepsf proa.psf
exit
