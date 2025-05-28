BEGIN {
  nres = 56;
  calc =  0;
  istr =  0;
  for (i=1; i<=nres; i++) freq_H[i] = 0;
  for (i=1; i<=nres; i++) freq_E[i] = 0
}

{ if ($1 == "SNAPSHOT") istr = istr + 1
  if (calc == 1) {
    if ($5 == "H") freq_H[$1] = freq_H[$1] + 1;
    if ($5 == "E") freq_E[$1] = freq_E[$1] + 1
  }
  if ($2 == "RESIDUE") calc = 1
  if ($1 == nres)      calc = 0
}

END {
  printf("RESNO    HELIX    SHEET\n")
  for (i=1; i<=nres; i++) {
    prop_H[i] = freq_H[i]/istr;
    prop_E[i] = freq_E[i]/istr;
    printf("%5d %8.5f %8.5f\n",i, prop_H[i], prop_E[i])
  }
}
