#!/bin/bash

## Get CV trajectories
cp /dev/null cv.dat
for i in {1..10}; do
	cat ../1_calc_dist/cv${i}.dat >> cv.dat
done

## Get boost potentials from a GENESIS log file
cp /dev/null out.dat
for i in {1..10}; do
	grep "^INFO" ../../5_production/run${i}.out >> out.dat
done

## Calculate a 1D PMF by reweighting 
./calc_pmf_1d.py -t 300.0 -c 10.0 -n 1000000 --Xmin 0.0 --Xmax 14.0 --Xdel 0.5  --cv_file cv.dat --out_file out.dat --anharm
mv pmf_1d.dat pmf_1d_reweight.dat

## If you do not reweight the GaMD boosts, add '--noreweight' option
./calc_pmf_1d.py -t 300.0 -c 10.0 -n 1000000 --Xmin 0.0 --Xmax 14.0 --Xdel 0.2  --cv_file cv.dat --out_file out.dat --noreweight
mv pmf_1d.dat pmf_1d_noreweight.dat
