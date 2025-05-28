# 1) Load psfgen-plugin and CHARMM topology file
package require psfgen
resetpsf
topology ../toppar/top_all36_prot.rtf
topology ../toppar/top_all36_na.rtf

# 2) Define a segment name for each chain
segment PROA {pdb proa.pdb}
segment DNA1 {first 5TER; last 3TER; pdb dna1.pdb}
segment DNA2 {first 5TER; last 3TER; pdb dna2.pdb}

# 3) Apply patches to convert RNA to DNA
patch DEO5 DNA1:1
for {set i 2} {$i <= 14} {incr i} {patch DEOX DNA1:$i}
patch DEO5 DNA2:1
for {set i 2} {$i <= 14} {incr i} {patch DEOX DNA2:$i}
regenerate angles dihedrals

# 4) Read the coordinates of atoms in each chain
coordpdb proa.pdb PROA
coordpdb dna1.pdb DNA1
coordpdb dna2.pdb DNA2

# 5) Guess the coordinates of missing atoms
guesscoord

# 6) Generate PDB and PSF files
writepdb complex.pdb
writepsf complex.psf

exit
