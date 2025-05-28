# 1) Load psfgen-plugin and CHARMM topology file
package require psfgen
resetpsf
topology ../toppar/top_all36_prot.rtf

# 2) Define a segment name for each chain
segment PROA {pdb proa.pdb}

# 3) Apply patches to protonate high pKa residues
patch ASPP PROA:26
regenerate angles dihedrals

# 4) Read the coordinates of atoms in each chain
coordpdb proa.pdb PROA

# 5) Guess the coordinates of missing atoms
guesscoord

# 6) Generate PDB and PSF files
writepdb protein.pdb
writepsf protein.psf

exit
