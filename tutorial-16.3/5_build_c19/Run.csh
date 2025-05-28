#!/bin/csh

# User-defined parameters
set NUMDECOYS = 50

# Create PDB and PSF files
set i = 1
while ($i <= $NUMDECOYS)
  echo "Run psfgen for model $i"

  # Convert PDB file for psfgen
  $CONVPDBPL -out charmm19 -setseg PROA ../4_fix_errors_2/model${i}.pdb > ./tmp/conv.pdb

  # Run psfgen using VMD
  $VMDBIN -dispdev text -e build.tcl > log${i}

  # rename the output PDB file
  mv model.pdb model${i}.pdb

  @ i = $i + 1
end
