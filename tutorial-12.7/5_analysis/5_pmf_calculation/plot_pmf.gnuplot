set terminal jpeg
set output "PMF_distance.jpg"
set xrange [0:14]
set yrange [0:5]
set xlabel "End to End Distance (Å)"
set ylabel "PMF (kcal/mol)"
plot "dist.pmf" u 1:2 w l notitle
