#!/bin/bash

~/Soft/gnuplot/bin/gnuplot -p << EOF
ndata=50000
bin(x,width)=width*floor(x/width)
binwidth=0.05
unset key
p for [k=1:14] "cv".k.".dat" u (bin(\$2,binwidth)):(1.0/ndata) w l smooth freq
EOF
