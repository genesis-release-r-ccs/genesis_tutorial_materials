# plot energy components
cat << EOF > tmp.plt
set term png
set mxtics
set mytics
set xlabel "End-to-End Distance (Angstrom)"
set ylabel "Potential of Mean Force (kcal/mol)"
set output "output_pmf.png"
set xrange[0:14]
set yrange[0:5]
plot "dist.pmf" with l lc rgb "blue" title "Ala3"
EOF

gnuplot tmp.plt
rm -rf tmp*
