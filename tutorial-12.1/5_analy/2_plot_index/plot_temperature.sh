#! /bin/bash -f

# get replica temperatures in each snapshot
grep "Parameter    :" ../../4_prod_remd/run.log | sed 's/Parameter    ://' > T-REMD_repID-Temperature.dat

# add step number
grep "REMD> Step:" ../../4_prod_remd/run.log | cut -c 12-25 > step.log
paste step.log T-REMD_repID-Temperature.dat > T-REMD_repID-Temperature.log

rm step.log
