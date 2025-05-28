#!/bin/bash

~/Soft/gnuplot/bin/gnuplot -p << EOF
set term svg size 600, 400
set output "eq_box_z.svg"

set xlabel "Time (ps)"
set ylabel "Box z size (angstrom)"

p [][117:132] \\
"log3.dat" u (\$3+50):21 w l ti "eq3", \\
"log4.dat" u (\$3+75):21 w l ti "eq4", \\
"log5.dat" u (\$3+175):21 w l ti "eq5", \\
"log6.dat" u (\$3+275):21 w l ti "eq6", \\
"log7.dat" u (\$3+475):20 w l ti "eq7"
EOF
