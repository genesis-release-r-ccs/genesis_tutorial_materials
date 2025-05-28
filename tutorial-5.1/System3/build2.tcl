# 1) Load psfgen-plugin and CHARMM topology file
package require psfgen
resetpsf
topology ../toppar/top_all36_prot.rtf
topology ../toppar/toppar_water_ions.str

# 2) Define a segment name for each chain
segment PROA {pdb proa.pdb }
segment SOLV {pdb water.pdb} 
segment CAL  {pdb cal.pdb  }

# 3) Read the coordinates of atoms in each chain
coordpdb proa.pdb  PROA 
coordpdb water.pdb SOLV
coordpdb cal.pdb   CAL

# 4) Guess the coordinates of missing atoms
guesscoord

# 5) Generate PDB and PSF files
writepdb protein.pdb
writepsf protein.psf

exit
