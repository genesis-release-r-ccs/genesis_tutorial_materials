#!/bin/bash -f

# get replica IDs in each snapshot
grep "ParmIDtoRepID:" ../../02_REMD/remd_master.log | sed 's/ParmIDtoRepID://' > T-REMD_parmID-repID.dat 

# get replica temperatures in each snapshot
grep "Parameter    :" ../../02_REMD/remd_master.log | sed 's/Parameter    ://' > T-REMD_repID-Temperature.dat

# get step number and combine to replica index
grep "REMD> Step:" ../../02_REMD/remd_master.log | cut -c 12-25 > step.log

# adding simulation steps in the beginning
paste step.log T-REMD_parmID-repID.dat > T-REMD_parmID-repID.log
paste step.log T-REMD_repID-Temperature.dat > T-REMD_repID-Temperature.log 

# remove tmp files
rm -f T-REMD_parmID-repID.dat T-REMD_repID-Temperature.dat step.log
