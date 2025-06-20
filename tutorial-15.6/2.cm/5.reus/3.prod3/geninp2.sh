#!/bin/bash

if [ $# -lt 2 ]; then
  echo "USAGE: geninp.sh newname oldname [fc]"
  echo "  newname: the name of new file (NEWNAME in template.inp)"
  echo "  oldname: the name of old rstfile (OLDNAME in template.inp)"
  echo "  fc: (optional) force constant (default = 100)"
  exit 0
fi

newname=$1
oldname=$2

if [ $# -lt 3 ]; then
  fc0=100.0
else
  fc0=$3
fi

nimg=$(wc ../0.window/win_rr.dat |awk '{print $1}')
#echo $nimg

r1=($(cat ../0.window/win_rr.dat |awk '{print $2}'))
r2=($(cat ../0.window/win_rr.dat |awk '{print $3}'))

cr1=${r1[@]}
cr2=${r2[@]}

cfc=" "
for i in `seq 1 $nimg`; do
  cfc=$cfc$fc0"  "
done
#echo $cfc
#echo ${r1[@]}

sed "s/NREP/$nimg/" template.inp > aa
sed "s/R1/${cr1}/" aa  > bb
mv bb aa
sed "s/R2/${cr2}/" aa  > bb
mv bb aa
sed "s/FC1/${cfc}/" aa  > bb
mv bb aa
sed "s/FC2/${cfc}/" aa  > bb
mv bb aa
sed "s#OLDNAME#$oldname#" aa > bb
mv bb aa
sed "s#NEWNAME#$newname#" aa > bb
mv bb ${newname}_reus.inp
rm aa

exit 0

