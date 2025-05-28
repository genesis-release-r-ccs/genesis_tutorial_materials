#!/bin/bash

gnuplot << EOF
set term jpeg size 600, 400
set output "rmsf.jpg"

set xlabel "Residue id"
set ylabel "RMSF (angstrom)"

p [][] "run2.rms" u 2:4 w l ti "RMSF"
EOF
