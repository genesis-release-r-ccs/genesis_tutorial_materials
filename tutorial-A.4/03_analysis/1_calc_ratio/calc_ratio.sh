#! /bin/bash -f

# get acceptance ratios between adjacent parameter IDs
grep "  1 >     2" ../../02_REMD/remd_master.log | tail -1  > acceptance_ratio.dat
grep "  3 >     4" ../../02_REMD/remd_master.log | tail -1 >> acceptance_ratio.dat
grep "  5 >     6" ../../02_REMD/remd_master.log | tail -1 >> acceptance_ratio.dat
grep "  7 >     8" ../../02_REMD/remd_master.log | tail -1 >> acceptance_ratio.dat
grep "  9 >    10" ../../02_REMD/remd_master.log | tail -1 >> acceptance_ratio.dat
grep " 11 >    12" ../../02_REMD/remd_master.log | tail -1 >> acceptance_ratio.dat
grep " 13 >    14" ../../02_REMD/remd_master.log | tail -1 >> acceptance_ratio.dat
grep " 15 >    16" ../../02_REMD/remd_master.log | tail -1 >> acceptance_ratio.dat

# show the results
awk '{print $2,$3,$4,$6/$8}' acceptance_ratio.dat
