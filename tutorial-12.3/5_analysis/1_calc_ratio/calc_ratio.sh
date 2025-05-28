#!/bin/bash

# get acceptance ratios between adjacent parameter IDs
grep "  1 >     2" ../../4_production/step4.out | tail -1  > acceptance_ratio.dat
grep "  2 >     3" ../../4_production/step4.out | tail -1 >> acceptance_ratio.dat
grep "  3 >     4" ../../4_production/step4.out | tail -1 >> acceptance_ratio.dat

# calculate the ratios
awk '{print $2,$3,$4,$6/$8}' acceptance_ratio.dat
