#!/bin/csh

set ista = 0
set iend = 100

echo -n > input_all.pml
@ i = $ista
while ($i <= $iend)
  set IDX = `echo "$i" | awk '{printf("%04d",$1)}'`
  sed -e "s/AAA/$i/g" template.pml | sed -e "s/BBB/$IDX/g" >> input_all.pml
  @ i = $i + 1
end
