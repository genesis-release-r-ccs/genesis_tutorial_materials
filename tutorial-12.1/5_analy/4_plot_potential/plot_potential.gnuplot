# load "plot_potential.gnuplot"
set terminal jpeg
set output "pot-tempretures.jpg"
set key below
set xlabel "Potential Energy (kcal/mol)"
set ylabel "Probability"
binwidth=50
bin(x,width)=width*floor(x/width)
ndata=2000
plot for [k=1:20] "potential_parmID".k.".log" u (bin($2,binwidth)):(1.0/ndata) t "Tempreture".k with lines smooth freq

