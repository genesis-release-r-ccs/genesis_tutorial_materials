#!/bin/bash

~/Soft/gnuplot/bin/gnuplot << EOF
set term png font "Arial, 14"
set output "pmf.png"
set grid
set key top center
#set size square
set encoding iso
set xlabel "End-to-end distance (\\305)"
set ylabel "PMF (kcal/mol)"
p [][0:5] \\
"pmf_1d_noreweight.dat" u 1:2 w l lw 1.5 ti "Not reweighted", \\
"pmf_1d.dat" u 1:2 w l lw 1.5 ti "Reweighted"
EOF
