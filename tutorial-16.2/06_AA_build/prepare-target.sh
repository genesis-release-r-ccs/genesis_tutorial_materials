#!/bin/bash

sed 's/[-]/ /g' open.pdb > CG_open2.pdb
for LINE in `seq 1 9`
do
    grep "X   ${LINE}" ../04_CG_analysis/CG_open.pdb  > temp1
    position=$(sed "s/.*X   ${LINE}//;s/ 1.00 .*//" temp1)
    sed -i "/CA/{s/A   ${LINE}[ ]*[0-9]*.[0-9]*[ ]*[0-9]*.[0-9]*[ ]*[0-9]*.[0-9]* /A   ${LINE}${position}/g}" CG_open2.pdb
done

for LINE in `seq 10 99`
do
    grep "X  ${LINE}" ../04_CG_analysis/CG_open.pdb  > temp1
    position=$(sed "s/.*X  ${LINE}//;s/ 1.00 .*//" temp1)
    sed -i "/CA/{s/A  ${LINE}[ ]*[0-9]*.[0-9]*[ ]*[0-9]*.[0-9]*[ ]*[0-9]*.[0-9]* /A  ${LINE}${position}/g}" CG_open2.pdb
done

for LINE in `seq 100 214`
do
    grep "X ${LINE}" ../04_CG_analysis/CG_open.pdb  > temp1
    position=$(sed "s/.*X ${LINE}//;s/ 1.00 .*//" temp1)
    sed -i "/CA/{s/A ${LINE}[ ]*[0-9]*.[0-9]*[ ]*[0-9]*.[0-9]*[ ]*[0-9]*.[0-9]* /A ${LINE}${position}/g}" CG_open2.pdb
done
rm temp1






