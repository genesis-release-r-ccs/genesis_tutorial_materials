#!/bin/bash

# get potential energy of each replica
for i in {1..16}
do
    grep "INFO:" ../3_sort_dcd/remd_paramID$i.log | tail -n +2 | awk '{print  $5}' > potential_energy_rep$i.dat
done

# insert step number to the beginning of each line
grep "INFO:" ../3_sort_dcd/remd_paramID1.log  | tail -n +2 | awk '{print $2}' > step.log
for i in {1..16}
do
    paste step.log potential_energy_rep$i.dat > potential_energy_rep$i.pot
done

# cleaning
rm -f potential*.dat step.log
