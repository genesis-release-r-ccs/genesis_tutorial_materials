#!/bin/csh

# User-defined parameters
set NUMDECOYS = 50

# Check structures
echo "chirality error check ============="
grep "suspicious chiral" log*
echo " "

echo "ring penetration check ============"
grep "suspicious ring" log*
echo " "

echo "cis peptide bond check  ==========="
set i = 1
while ($i <= $NUMDECOYS)
  echo "model $i"
  $VMDBIN -dispdev text -e ./template/cispeptide.vmd model${i}.pdb | grep "cispeptide)"
  @ i = $i + 1
end
