#!/bin/bash

bindir=/path/to/bin
cp ../3.1_dRMS/drms.out drms_1.out
wait
${bindir}/pmf_analysis pmf_2d_drms.inp | tee  pmf_2d_drms.log
wait
tclsh pmf_2d_edit.tcl
