# 1) Load psfgen-plugin and CHARMM topology file
package require psfgen
resetpsf
topology ../toppar/top_all36_prot.rtf

# 2) Define a segment name for each chain
segment PROA {pdb proa.pdb}
segment PROB {pdb prob.pdb}

# 3) Apply patches to make disulfide bonds
patch DISU PROA:6  PROA:11
patch DISU PROA:7  PROB:7
patch DISU PROA:20 PROB:19
regenerate angles dihedrals

# 4) Read the coordinates of atoms in each chain
coordpdb proa.pdb PROA
coordpdb prob.pdb PROB

# 5) Guess the coordinates of missing atoms
guesscoord

# 6) Generate PDB and PSF files
writepdb protein.pdb
writepsf protein.psf

exit
