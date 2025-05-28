#!/bin/csh

set ista = 0
set iend = 100

@ i = $ista
while ($i <= $iend)
  set IDX    = `echo "$i" | awk '{printf("%04d",$1)}'`

  # Calculate the simulation time of each snapshot
  set simtim = `echo "$i" | awk '{printf("%3d",$1)}'`

  echo "IDX = $IDX  simtim = $simtim"

  # run the convert command
  convert -font Nimbus-Mono-Bold -pointsize 32 \
          -gravity northeast -fill "black"     \
          -draw "text 30,20 '${simtim} ps'"    \
          ../2_makepng/md$IDX.png md$IDX.png

  @ i = $i + 1
end
