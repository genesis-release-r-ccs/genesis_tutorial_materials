package require psfgen
resetpsf
topology ../toppar/top_all36_prot.rtf
segment PROA {pdb proa.pdb} 
coordpdb proa.pdb PROA
guesscoord 
writepdb protein.pdb
writepsf protein.psf

package require solvate
set psffile "protein.psf"
set pdbfile "protein.pdb"
solvate $psffile $pdbfile -minmax {{-32 -32 -32} {32 32 32}} -o wbox

package require autoionize
set psffile "wbox.psf"
set pdbfile "wbox.pdb"
autoionize -psf $psffile -pdb $pdbfile -sc 0.15 -cation SOD -anion CLA

exit
