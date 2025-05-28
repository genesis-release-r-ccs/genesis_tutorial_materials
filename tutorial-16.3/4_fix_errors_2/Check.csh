#!/bin/csh

# User-defined parameters
set NUMDECOYS = 50

# Check structures
echo "cis peptide bond check  ==========="
set i = 1
while ($i <= $NUMDECOYS)
  echo "model $i"
  $VMDBIN -dispdev text -e ./template/cispeptide.vmd model${i}.pdb > cispeptide${i}.log
  grep "cispeptide)" cispeptide${i}.log
  @ i = $i + 1
end
