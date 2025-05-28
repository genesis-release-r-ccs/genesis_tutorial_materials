#!/bin/bash

bindir=/path/to/bin
export OMP_NUM_THREADS=1
${bindir}/pmf_analysis pmf.inp | tee pmf.log
wait
tclsh pmf_1d_edit.tcl
wait
tclsh keq_pmf.tcl pmf_plot.out
