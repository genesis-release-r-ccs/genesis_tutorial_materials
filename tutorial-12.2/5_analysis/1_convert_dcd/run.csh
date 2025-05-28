#!/bin/csh

@ i = 1
while ($i <= 14)
  ../../bin/crd_convert INP$i > log$i
  @ i = $i + 1
end
