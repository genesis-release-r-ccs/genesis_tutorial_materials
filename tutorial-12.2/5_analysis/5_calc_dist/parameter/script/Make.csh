#!/bin/csh

@ i = 1
while ($i <= 14)
  sed -e "s/INDEX/$i/g" template.inp > ../INP$i
  @ i++
end
