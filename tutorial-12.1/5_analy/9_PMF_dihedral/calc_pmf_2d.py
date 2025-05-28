#!/usr/bin/env python

import sys, math
import numpy as np
import argparse

if __name__ == '__main__':

  parser = argparse.ArgumentParser()
  parser.add_argument('-t', '--temperature', dest='temperature', help='temperature')
  parser.add_argument('-c', '--cutoff', dest='cutoff', default='10.0', help='Lower limit of #samples in bins')
  parser.add_argument('-n', '--nsample', dest='nsample', required=True, help='number of samples')
  parser.add_argument('--Xmin', dest='min1', required=True, help='Minimum of x grid')
  parser.add_argument('--Xmax', dest='max1', required=True, help='Maximum of x grid')
  parser.add_argument('--Xdel', dest='delta1', required=True, help='Width of x grid')
  parser.add_argument('--Ymin', dest='min2', required=True, help='Minimum of y grid')
  parser.add_argument('--Ymax', dest='max2', required=True, help='Maximum of y grid')
  parser.add_argument('--Ydel', dest='delta2', required=True, help='Width of y grid')
  parser.add_argument('--cv_file', dest='cv_file', required=True, help='name of file containing CV')
  parser.add_argument('--weight_file', dest='weight_file', required=True, help='name of file containing CV')
  parser.add_argument('--out_file', dest='out_file', required=True, help='name of Ofile')
  parser.add_argument('--Xcyclic', action='store_const', const=True, default=False, help='x grid is cyclic or not')
  parser.add_argument('--Ycyclic', action='store_const', const=True, default=False, help='y grid is cyclic or not')
  args = parser.parse_args()

  temperature = float(args.temperature)
  cutoff = float(args.cutoff)
  nsample = int(args.nsample)
  min1 = float(args.min1)
  max1 = float(args.max1)
  delta1 = float(args.delta1)
  min2 = float(args.min2)
  max2 = float(args.max2)
  delta2 = float(args.delta2)
  cv_file = args.cv_file
  weight_file = args.weight_file
  out_file = args.out_file
  xcyclic_flag = args.Xcyclic
  ycyclic_flag = args.Ycyclic


  nbin_max = 1000000
  fe_max = 10000000.0
  num1 = int((max1-min1) / delta1)
  num2 = int((max2-min2) / delta2)
  RT = 8.314 * temperature / 1000.0
  RT_kcal = 8.314 * temperature / 4.184 / 1000.0
  beta = (1000.0 * 4.184) / (8.314 * temperature)


  #
  # Get MBAR weight
  #
  weights = np.ones([nsample], float)
  if weight_file != '':
    j = 0
    for line in open(weight_file):
      a = line.split()
      weights[j] = float(a[1])
      j += 1


  #
  # Calculate number of samples and averages in each bin.
  #
  nsample_in_bin = np.zeros([num1, num2], int)
  weights_in_bin = np.zeros([num1, num2], float)
  j = 0
  for line in open(cv_file):
    a = line.split()
    cv1 = float(a[1])
    cv2 = float(a[2])
    idx1 = int((cv1 - min1)/delta1)
    idx2 = int((cv2 - min2)/delta2)
    if xcyclic_flag:
      if idx1 >= num1:
        idx1 -= num1
    if ycyclic_flag:
      if idx2 >= num2:
        idx2 -= num2
    nsample_in_bin[idx1,idx2] += 1
    weights_in_bin[idx1,idx2] += weights[j]
    j += 1

  #
  # Calculate the free energy in each bin
  #
  fe = np.zeros([num1, num2], float)
  fe_min = fe_max
  for j in range(num2):
    for i in range(num1):
      if nsample_in_bin[i,j] <= cutoff:
        fe[i,j] = fe_max
      else:
        if nsample_in_bin[i,j] > cutoff:
          fe[i,j] = - RT_kcal * np.log(weights_in_bin[i,j])
      if fe[i,j] < fe_min:
        fe_min = fe[i,j]
  fe -= fe_min

  #
  # Output
  #
  f = open("xi.dat", "w")
  for i in range(num1):
    f.write("%f " % (min1+i*delta1+0.5*delta1))
    f.write("\n")
  f.close()

  f = open("yi.dat", "w")
  for i in range(num2):
    f.write("%f " % (min2+i*delta2+0.5*delta2))
    f.write("\n")
  f.close()

  f = open(out_file, "w")
  for j in range(num2):
    for i in range(num1):
      f.write("%f " % fe[i,j])
    f.write("\n")
  f.close()
