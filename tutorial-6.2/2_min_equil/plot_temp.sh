#!/bin/bash

~/Soft/gnuplot/bin/gnuplot -p << EOF
set term svg size 600, 400
set output "eq_temp.svg"

set xlabel "Time (ps)"
set ylabel "Temperature (K)"

p [][280:325] \\
"log1.dat" u 3:17 w l ti "eq1", \\
"log2.dat" u (\$3+25):17 w l ti "eq2", \\
"log3.dat" u (\$3+50):17 w l ti "eq3", \\
"log4.dat" u (\$3+75):17 w l ti "eq4", \\
"log5.dat" u (\$3+175):17 w l ti "eq5", \\
"log6.dat" u (\$3+275):17 w l ti "eq6", \\
"log7.dat" u (\$3+475):16 w l ti "eq7"
EOF
