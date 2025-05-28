#!/bin/csh

@ i = 1
while ($i <= 14)
  ../../../bin/trj_analysis INP$i > log$i
  @ i++
end
