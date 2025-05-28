set encoding iso_8859_1
set termopt enhanced
set ylabel "PMf, kcal/mol"
set xlabel "dRMS_{Closed}, \305"
set key horiz
set key font ",20"
set xtics font ",16"
set ytics font ",16"
set xlabel font ",20"
set ylabel font ",20"
#set xrange [0:19]
plot "pmf_1d_drms_plot.out" using 1:2 every 1 with lines linewidth 1 linecolor rgb "web-blue" title ""
set terminal pngcairo lw 5
#set border 1248 lw 5 lt 1
set output "pmf_1d_drms_plot.png"
replot

