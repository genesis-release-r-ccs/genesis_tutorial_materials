#!/bin/csh

# User-defined parameters
set NUMDECOYS = 50

# Create PDB and PSF files
set i = 1
while ($i <= $NUMDECOYS)
  echo "Run psfgen for model $i"

  # Convert PDB file for psfgen
  $CONVPDBPL -setseg PROA ../1_pulchra/model${i}.rebuilt.pdb > ./tmp/conv.pdb

  # Run psfgen using VMD
  $VMDBIN -dispdev text -e build.tcl > log${i}

  # rename the output PDB file
  mv model.pdb model${i}.pdb

  @ i = $i + 1
end
