set encoding iso_8859_1
set termopt enhanced
set terminal pngcairo lw 5
set output "drms.png"

set multiplot layout 1,2 columnsfirst

set lmargin at screen 0.15
set rmargin at screen 0.95

set tmargin at screen 0.85
set bmargin at screen 0.50
set format x ''
set format y '%.0f'
set ylabel "{/Helvetica-Italic dRMS}_{closed}, \305" offset -1 font "Helvetica, 18"
set yrange [0:15]
set ytics 3 font "Helvetica, 20"
set xtics 500 font "Helvetica, 20"
plot "drms.out" using 1:2 every 1 with lines linewidth 0.3 linecolor rgb "web-blue" title ""

set tmargin at screen 0.50
set bmargin at screen 0.15
set format x '%.0f'
set format y '%.0f'
set xlabel "timestep" font "Helvetica, 20"
set ylabel "{/Helvetica-Italic dRMS}_{open}, \305" offset -1 font "Helvetica, 18"
set yrange [0:10]
set ytics 3 font "Helvetica, 20"
plot "drms.out" using 1:3 every 1 with lines linewidth 0.3 linecolor rgb "dark-pink" title ""

replot
unset multiplot
set term x11

#pause -1 "Hit any key to continue"
