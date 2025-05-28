#!/bin/sh 

for REP in `seq 1 32`
    do
    grep 'INFO:' ../03_CG_REMD_fitting/log_${REP}.log | awk '{printf ("%10s\t%20s\n",$2,$15)}' | grep -v "RESTR"  > temp1
    awk -v var=log_${REP}.log '{print var,"\t",$0}' temp1 > cc-list$REP
    rm temp1
    highest_cc=$(awk '{print $3}' cc-list$REP | sort -n | tail -1)
    grep "$highest_cc" cc-list$REP  >> temp2
done

sort -rk3 temp2 > the-highest-cc.txt
rm temp2





