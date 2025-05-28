#! /bin/bash -f


# get potential energy of each temperature
grep "INFO:" ../3_sort/parmID1.log   | tail -n +2 | awk '{print $2, $5}' > potential_parmID1.log
grep "INFO:" ../3_sort/parmID2.log   | tail -n +2 | awk '{print $2, $5}' > potential_parmID2.log
grep "INFO:" ../3_sort/parmID3.log   | tail -n +2 | awk '{print $2, $5}' > potential_parmID3.log
grep "INFO:" ../3_sort/parmID4.log   | tail -n +2 | awk '{print $2, $5}' > potential_parmID4.log
grep "INFO:" ../3_sort/parmID5.log   | tail -n +2 | awk '{print $2, $5}' > potential_parmID5.log
grep "INFO:" ../3_sort/parmID6.log   | tail -n +2 | awk '{print $2, $5}' > potential_parmID6.log
grep "INFO:" ../3_sort/parmID7.log   | tail -n +2 | awk '{print $2, $5}' > potential_parmID7.log
grep "INFO:" ../3_sort/parmID8.log   | tail -n +2 | awk '{print $2, $5}' > potential_parmID8.log
grep "INFO:" ../3_sort/parmID9.log   | tail -n +2 | awk '{print $2, $5}' > potential_parmID9.log
grep "INFO:" ../3_sort/parmID10.log  | tail -n +2 | awk '{print $2, $5}' > potential_parmID10.log
grep "INFO:" ../3_sort/parmID11.log  | tail -n +2 | awk '{print $2, $5}' > potential_parmID11.log
grep "INFO:" ../3_sort/parmID12.log  | tail -n +2 | awk '{print $2, $5}' > potential_parmID12.log
grep "INFO:" ../3_sort/parmID13.log  | tail -n +2 | awk '{print $2, $5}' > potential_parmID13.log
grep "INFO:" ../3_sort/parmID14.log  | tail -n +2 | awk '{print $2, $5}' > potential_parmID14.log
grep "INFO:" ../3_sort/parmID15.log  | tail -n +2 | awk '{print $2, $5}' > potential_parmID15.log
grep "INFO:" ../3_sort/parmID16.log  | tail -n +2 | awk '{print $2, $5}' > potential_parmID16.log
grep "INFO:" ../3_sort/parmID17.log  | tail -n +2 | awk '{print $2, $5}' > potential_parmID17.log
grep "INFO:" ../3_sort/parmID18.log  | tail -n +2 | awk '{print $2, $5}' > potential_parmID18.log
grep "INFO:" ../3_sort/parmID19.log  | tail -n +2 | awk '{print $2, $5}' > potential_parmID19.log
grep "INFO:" ../3_sort/parmID20.log  | tail -n +2 | awk '{print $2, $5}' > potential_parmID20.log


