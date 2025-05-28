#!/bin/csh

# User-defined parameters
set NUMDECOYS = 50

# Submit jobs to a cluster machine using qsub
set i = 1
while ($i <= $NUMDECOYS)
  qsub job$i.sh
  @ i = $i + 1
end
