#!/bin/csh

# User-defined parameters
set NUMDECOYS = 50

# Create GENESIS control files and job scripts
set i = 1
while ($i <= $NUMDECOYS)
  sed -e "s/MODELID/$i/g" ./template/job.sh > job$i.sh
  sed -e "s/MODELID/$i/g" ./template/INP    > INP$i
  @ i = $i + 1
end
