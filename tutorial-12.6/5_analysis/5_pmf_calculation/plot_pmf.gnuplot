set terminal jpeg
set output "PMF_distance.jpg"
set xrange [0:13]
set yrange [0:10]
set xlabel "End to End Distance (Å)"
set ylabel "PMF (kcal/mol)"
plot "dist.pmf" u 1:2 w l notitle
