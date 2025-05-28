#!/bin/csh

# User-defined parameters
set NUMDECOYS  = 50

# Run PULCHRA
set i = 1
while ($i <= $NUMDECOYS)
  echo "Run PULCHRA for model $i"
  $PULCHRABIN ../0_data/model${i}.pdb
  mv ../0_data/model${i}.rebuilt.pdb ./
  @ i = $i + 1
end
