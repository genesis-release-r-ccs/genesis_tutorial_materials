#!/bin/bash

bindir=/path/to/bin
export OMP_NUM_THREADS=1
cp ../3.1_dRMS/drms.out drms_1.out
wait
${bindir}/pmf_analysis pmf_1d_drms.inp | tee  pmf_1d_drms.log
wait
tclsh pmf_1d_edit.tcl
