#!/bin/bash

# get replica temperatures in each snapshot
grep "Parameter    :" ../../4_production/step4.out | sed 's/Parameter    :/ /' > temperature.dat

# plot replica temperatures in each snapshot
cat << EOF > tmp.plt
set term png
set mxtics
set mytics
set xlabel "Time (ns)"
set ylabel "Temperature (K)"
set output "output_temperature_rep1.png"
plot "temperature.dat" using (\$0*10.5/1000):1  with lines lc rgb "blue" title "repID=1 "
set output "output_temperature_rep2.png"
plot "temperature.dat" using (\$0*10.5/1000):2  with lines lc rgb "blue" title "repID=2 "
set output "output_temperature_rep3.png"
plot "temperature.dat" using (\$0*10.5/1000):3  with lines lc rgb "blue" title "repID=3 "
set output "output_temperature_rep4.png"
plot "temperature.dat" using (\$0*10.5/1000):4  with lines lc rgb "blue" title "repID=4 "
EOF

gnuplot tmp.plt
rm -rf tmp*
