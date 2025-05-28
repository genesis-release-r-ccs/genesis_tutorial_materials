# 1) Load psfgen-plugin and CHARMM topology file
package require psfgen
resetpsf
topology ../toppar/top_all36_prot.rtf

# 2) Define a segment name for each chain
segment PROA {pdb proa.pdb}

# 3) Read the coordinates of atoms in each chain
coordpdb proa.pdb PROA

# 4) Guess the coordinates of missing atoms
guesscoord

# 5) Generate PDB and PSF files
writepdb protein.pdb
writepsf protein.psf

exit
