#! /bin/bash -f

# get replica IDs in each snapshot
grep "ParmIDtoRepID:" ../../4_prod_remd/run.log | sed 's/ParmIDtoRepID://' > T-REMD_parmID-repID.dat

# add step number
grep "REMD> Step:" ../../4_prod_remd/run.log | cut -c 12-25 > step.log
paste step.log T-REMD_parmID-repID.dat > T-REMD_parmID-repID.log


rm step.log
