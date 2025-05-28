#!/bin/sh

export OMP_NUM_THREADS=1

# MBAR reweighting
../bin/mbar_analysis INP > log
