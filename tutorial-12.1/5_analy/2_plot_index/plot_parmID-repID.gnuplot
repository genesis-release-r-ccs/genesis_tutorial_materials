# load "plot_parmID-repID.gnuplot"
set terminal jpeg
reset
set yrange [0:22]
set mxtics
set mytics
set xlabel "Time (ns)"
set ylabel "Replica ID"
set output "300.00k.jpg"
plot "T-REMD_parmID-repID.log" using ($1*0.0025*0.001):2  with points pt 5 ps 0.5 lt 1 title "300.00 K"
set output "323.46k.jpg"
plot "T-REMD_parmID-repID.log" using ($1*0.0025*0.001):11 with points pt 7 ps 0.5 lt 2 title "323.46 K"
set output "351.30k.jpg"
plot "T-REMD_parmID-repID.log" using ($1*0.0025*0.001):21 with points pt 9 ps 0.5 lt 3 title "351.30 K"
