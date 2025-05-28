#!/bin/bash

~/Soft/gnuplot/bin/gnuplot << EOF
set term svg size 600, 400
set output "min_ene.svg"

set xlabel "Step"
set ylabel "Energy (kcal/mol)"

p [][] \\
"log_min.dat" u 2:3 w l ti "min", \\
EOF
