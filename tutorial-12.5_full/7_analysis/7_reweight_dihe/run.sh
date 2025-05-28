#!/bin/bash

## Set number of samples
nsample=700000

## Get CV trajectories
cp /dev/null cv.dat
for i in {1..14}; do
	cat ../6_calc_dihe/cv${i}.dat >> cv.dat
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

## Calculate a 2D PMF by reweighting 
python ./calc_pmf_2d.py -t 300.0 -c 10.0 -n $nsample --Xmin -180.0 --Xmax 180.0 --Xdel 20.0 --Ymin -180.0 --Ymax 180.0 --Ydel 20.0 --cv_file cv.dat --out_file out.dat --weight_file weight.dat --Xcyclic --Ycyclic --anharm
## Calculate a 2D PMF without reweighting
#python ./calc_pmf_2d.py -t 300.0 -c 10.0 -n $nsample --Xmin -180.0 --Xmax 180.0 --Xdel 20.0 --Ymin -180.0 --Ymax 180.0 --Ydel 20.0 --cv_file cv.dat --out_file out.dat --weight_file weight.dat --Xcyclic --Ycyclic --noreweight

## Plot a 2D PMF
python ./plot_2d.py
python ./plot_anharm.py
