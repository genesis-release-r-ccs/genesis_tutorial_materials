#!/bin/bash

## Get CV trajectories
cp /dev/null cv.dat
for i in {1..10}; do
	cat ../3_calc_dihe/cv${i}.dat >> cv.dat
done

## Get boost potentials from a GENESIS log file
cp /dev/null out.dat
for i in {1..10}; do
	grep "^INFO" ../../5_production/run${i}.out >> out.dat
done

## Calculate a 2D PMF by reweighting 
./calc_pmf_2d.py -t 300.0 -c 10.0 -n 1000000 --Xmin -180.0 --Xmax 180.0 --Xdel 20.0 --Ymin -180.0 --Ymax 180.0 --Ydel 20.0 --cv_file cv.dat --out_file out.dat --Xcyclic --Ycyclic --anharm
## Calculate a 2D PMF withou reweighting
#./calc_pmf_2d.py -t 300.0 -c 10.0 -n 1000000 --Xmin -180.0 --Xmax 180.0 --Xdel 20.0 --Ymin -180.0 --Ymax 180.0 --Ydel 20.0 --cv_file cv.dat --out_file out.dat --Xcyclic --Ycyclic --noreweight

## Plot a 2D PMF
#./plot_2d.py
