#!/bin/bash

gnuplot -p << EOF
set term jpeg size 600, 400
set output "rmsd.jpg"

set xlabel "Time (ns)"
set ylabel "RMSD (angstrom)"

p [][0:] "rmsd.dat" u (\$1/100):2 w l ti "RMSD"
EOF
