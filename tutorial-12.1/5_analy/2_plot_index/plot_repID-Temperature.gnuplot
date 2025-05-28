# load "plot_repID-Temperature.gnuplot"
set terminal jpeg
set output "RepID1_10_20.jpg"
set yrange [300:360]
set mxtics
set mytics
set xlabel "Time (ns)"
set ylabel "Temperature (K)"
plot \
  "T-REMD_repID-Temperature.log" using ($1*0.0025*0.001):2  with lines lt 3 title "repID=1 ",\
  "T-REMD_repID-Temperature.log" using ($1*0.0025*0.001):11 with lines lt 2 title "repID=10",\
  "T-REMD_repID-Temperature.log" using ($1*0.0025*0.001):21 with lines lt 1 title "repID=20"
