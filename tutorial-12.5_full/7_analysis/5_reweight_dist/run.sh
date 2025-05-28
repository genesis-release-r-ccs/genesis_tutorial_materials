#!/bin/bash

## Set number of samples
nsample=700000

## Get CV trajectories
cp /dev/null cv.dat
for i in {1..14}; do
	cat ../3_calc_dist/cv${i}.dat >> cv.dat
done

## Get boost potentials from a GENESIS log file
cp /dev/null out.dat
for i in {1..14}; do
	grep "^INFO" ../2_sort_dcd/par${i}.log >> out.dat
done

## Get weight from mbar_analysis
cp /dev/null weight.dat
for i in {1..14}; do
	cat ../4_mbar/output${i}.weight >> weight.dat
done

## Calculate a 1D PMF by reweighting 
python ./calc_pmf_1d.py -t 300.0 -c 0.0 -n $nsample --Xmin 0.0 --Xmax 14.0 --Xdel 0.4 --cv_file cv.dat --out_file out.dat --weight_file weight.dat --anharm

## If you do not reweight the GaMD boosts, add '--noreweight' option
#python ./calc_pmf_1d.py -t 300.0 -c 0.0 -n $nsample --Xmin 0.0 --Xmax 14.0 --Xdel 0.2 --cv_file cv.dat --out_file out.dat --weight_file weight.dat --noreweight 
