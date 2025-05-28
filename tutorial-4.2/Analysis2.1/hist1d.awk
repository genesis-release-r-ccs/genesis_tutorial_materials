#  1D histogram analysis
#
BEGIN {
  xmin = 0.0; xmax = 15.0; binsizex = 0.1;
  nx   = (xmax - xmin)/binsizex;
  for (i=0; i<=nx; i++) freq[i]=0
}

{ i = int(($2 - xmin)/binsizex);
  freq[i] = freq[i] + 1 }

END {
  for (i=0; i<=nx; i++) {
    x0 = xmin + i*binsizex;
    print x0, freq[i], freq[i]/NR
  }
}
