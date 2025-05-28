#! /bin/bash -f

# get acceptance ratios between adjacent parameter IDs
grep "  1 >     2" ../../4_prod_remd/run.log | tail -1  > acceptance_ratio.dat
grep "  3 >     4" ../../4_prod_remd/run.log | tail -1 >> acceptance_ratio.dat
grep "  5 >     6" ../../4_prod_remd/run.log | tail -1 >> acceptance_ratio.dat
grep "  7 >     8" ../../4_prod_remd/run.log | tail -1 >> acceptance_ratio.dat
grep "  9 >    10" ../../4_prod_remd/run.log | tail -1 >> acceptance_ratio.dat
grep " 11 >    12" ../../4_prod_remd/run.log | tail -1 >> acceptance_ratio.dat
grep " 13 >    14" ../../4_prod_remd/run.log | tail -1 >> acceptance_ratio.dat
grep " 15 >    16" ../../4_prod_remd/run.log | tail -1 >> acceptance_ratio.dat
grep " 17 >    18" ../../4_prod_remd/run.log | tail -1 >> acceptance_ratio.dat
grep " 19 >    20" ../../4_prod_remd/run.log | tail -1 >> acceptance_ratio.dat

# show the results
awk '{printf ("%2d %s %2d %4.3f \n", $2,$3,$4,$6/$8)}' acceptance_ratio.dat
