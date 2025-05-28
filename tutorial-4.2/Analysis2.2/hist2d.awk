#  2D histogram analysis
#
BEGIN {
  xmin = -180.0; xmax = 180.0; binsizex = 10.0;
  ymin = -180.0; ymax = 180.0; binsizey = 10.0;
  nx   = (xmax - xmin)/binsizex;
  ny   = (ymax - ymin)/binsizey;
  for (i=0; i<=nx; i++) for (j=0; j<=ny; j++) freq[i,j]=0
}

{ i = int(($2 - xmin)/binsizex);
  j = int(($3 - ymin)/binsizey);
  freq[i,j] = freq[i,j] + 1 }

END {
  for (i=0; i<=nx; i++) {
    for (j=0; j<=ny; j++) {
      x0 = xmin + i*binsizex;
      y0 = ymin + j*binsizey;
      print x0, y0, freq[i,j], freq[i,j]/NR
    }
  print " "
  }
}
