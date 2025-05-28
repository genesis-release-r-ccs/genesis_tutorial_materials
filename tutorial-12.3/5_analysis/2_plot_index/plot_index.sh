#!/bin/bash

# get replica IDs in each snapshot
grep "ParmIDtoRepID:" ../../4_production/step4.out | sed 's/ParmIDtoRepID:/ /' > param.dat

# plot replica IDs in each snapshot
cat << EOF > tmp.plt
set term png
set yrange [0:5]
set mxtics
set mytics
set xlabel "Time (ns)"
set ylabel "Replica ID"
set output "output_index1.png"
plot "param.dat" using (\$0*10.5/1000):1 with points pt 5 ps 0.5 lc rgb "blue" title "300.00 K"
set output "output_index2.png"
plot "param.dat" using (\$0*10.5/1000):2 with points pt 5 ps 0.5 lc rgb "cyan" title "318.12 K"
set output "output_index3.png"
plot "param.dat" using (\$0*10.5/1000):3 with points pt 5 ps 0.5 lc rgb "green" title "337.14 K"
set output "output_index4.png"
plot "param.dat" using (\$0*10.5/1000):4 with points pt 5 ps 0.5 lc rgb "red" title "351.26 K"
EOF

gnuplot tmp.plt
rm -rf tmp*
