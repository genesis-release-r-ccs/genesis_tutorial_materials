#!/bin/bash

bindir=/path/to/bin
export OMP_NUM_THREADS=1
tclsh mbar_permute.tcl
wait
tclsh mbar_target.tcl
wait
${bindir}/mbar_analysis mbar.inp | tee mbar.log
