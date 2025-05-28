#!/usr/bin/env python

import sys, math, os
import numpy as np
import argparse

def calc_anharmonicity(boosts):
    if len(boosts) > 1:
        var = np.var(boosts)
        hist, bins = np.histogram(boosts, 50, density=True)
        hist += 1.0E-20
        dx = bins[1] - bins[0]
        gamma = 0.5 * np.log(2.0*np.pi*var) + 0.5
        gamma += np.trapz(hist*np.log(hist), dx=dx)
        if np.isinf(gamma):
           gamma = 100
    else:
        gamma = 100
    return gamma

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-t', '--temperature', dest='temperature', default='300', help='temperature')
    parser.add_argument('-c', '--cutoff', dest='cutoff', default='10.0', help='Lower limit of #samples in bins')
    parser.add_argument('-n', '--nsample', dest='nsample', required=True, help='number of samples')
    parser.add_argument('--Xmin', dest='min1', required=True, help='Minimum of x grid')
    parser.add_argument('--Xmax', dest='max1', required=True, help='Maximum of x grid')
    parser.add_argument('--Xdel', dest='delta1', required=True, help='Width of x grid')
    parser.add_argument('--Ymin', dest='min2', required=True, help='Minimum of y grid')
    parser.add_argument('--Ymax', dest='max2', required=True, help='Maximum of y grid')
    parser.add_argument('--Ydel', dest='delta2', required=True, help='Width of y grid')
    parser.add_argument('--cv_file', dest='cv_file', required=True, help='name of file containing CV')
    parser.add_argument('--out_file', dest='out_file', required=True, help='name of GENESIS output file')
    parser.add_argument('--weight_file', dest='weight_file', default='', help='name of MBAR weight file')
    parser.add_argument('--noreweight', action='store_const', const=True, default=False, help='Reweight or not')
    parser.add_argument('--Xcyclic', action='store_const', const=True, default=False, help='x grid is cyclic or not')
    parser.add_argument('--Ycyclic', action='store_const', const=True, default=False, help='y grid is cyclic or not')
    parser.add_argument('--anharm', action='store_const', const=True, default=False, help='calculate anharmonicity')
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
    out_file = args.out_file
    cv_file = args.cv_file
    weight_file = args.weight_file
    noreweight_flag = args.noreweight
    xcyclic_flag = args.Xcyclic
    ycyclic_flag = args.Ycyclic
    anharm_flag = args.anharm

    nbin_max = 1000000
    fe_max = 10000000.0
    num1 = int((max1-min1) / delta1)
    num2 = int((max2-min2) / delta2)
    RT = 8.314 * temperature / 1000.0
    RT_kcal = 8.314 * temperature / 4.184 / 1000.0
    beta = (1000.0 * 4.184) / (8.314 * temperature)

    ## Get boost potentials
    boosts = np.zeros([nsample], float)
    id_pot = -1
    id_dih = -1
    j = 0
    for line in open(out_file):
        if line.startswith("INFO"):
            a = line.split()
            if a[1] == "STEP":
                for i in range(len(a)):
                    if a[i] == "POTENTIAL_GAMD":
                        id_pot = i
                    elif a[i] == "DIHEDRAL_GAMD":
                        id_dih = i
            elif a[1].isdigit():
                out_step = int(a[1])
                pot = 0.0
                dih = 0.0
                if id_pot >= 0:
                    pot = float(a[id_pot])
                if id_dih >= 0:
                    dih = float(a[id_dih])
                boosts[j] = pot + dih
                j += 1

    ## Get MBAR weight
    weights = np.ones([nsample], float)
    if weight_file != '':
        j = 0
        for line in open(weight_file):
            a = line.split()
            weights[j] = float(a[1])
            j += 1
 
    ## Calculate number of samples and averages in each bin.
    nsample_in_bin = np.zeros([num1, num2], int)
    weights_in_bin = np.zeros([num1, num2], float)
    sample_to_bin = []
    ave = np.zeros([num1, num2], float)
    ave2 = np.zeros([num1, num2], float)
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
        ave[idx1,idx2]  += weights[j]*boosts[j]
        ave2[idx1,idx2] += weights[j]*boosts[j]**2
        sample_to_bin.append((idx1, idx2))
        j += 1

    ## Calculate the free energy in each bin
    fe = np.zeros([num1, num2], float)
    fe_noreweight = np.zeros([num1, num2], float)
    fe_min = fe_max
    for j in range(num2):
        for i in range(num1):
            if nsample_in_bin[i,j] == 0:
                fe[i,j] = fe_max
            else:
                if nsample_in_bin[i,j] > cutoff:
                    c1 = beta*ave[i,j]/weights_in_bin[i,j]
                    c2 = 0.5*beta**2*(ave2[i,j]/weights_in_bin[i,j] - (ave[i,j]/weights_in_bin[i,j])**2)
                    fe_noreweight[i,j] = - RT_kcal * np.log(weights_in_bin[i,j])
                    if noreweight_flag:
                        fe[i,j] = fe_noreweight[i,j]
                    else:
                        fe[i,j] = - RT_kcal * (c1+c2) + fe_noreweight[i,j]
            if fe[i,j] < fe_min:
                fe_min = fe[i,j]
    fe -= fe_min

    ## Output x grids
    f = open("xi.dat", "w")
    for i in range(num1):
        f.write("%f " % (min1+i*delta1+0.5*delta1))
    f.write("\n")
    f.close()

    ## Output y grids
    f = open("yi.dat", "w")
    for i in range(num2):
        f.write("%f " % (min2+i*delta2+0.5*delta2))
    f.write("\n")
    f.close()

    ## Output free energy on each grid
    f = open("pmf_2d.dat", "w")
    for j in range(num2):
        for i in range(num1):
            f.write("%f " % fe[i,j])
        f.write("\n")
    f.close()

    ## Calculate the anharmonicities in each bin
    if anharm_flag:
        anharm = np.zeros([num1, num2], float)
        for j in range(num2):
            for i in range(num1):
                a = np.zeros([nsample_in_bin[i,j]], float)
                k = 0
                for l in range(nsample):
                    if sample_to_bin[l] == (i,j):
                        a[k] = boosts[l]
                        k += 1
                anharm[i,j] = calc_anharmonicity(a)
        f = open("anharm_2d.dat", "w")
        for j in range(num2):
            for i in range(num1):
                f.write("%f " % anharm[i,j])
            f.write("\n")
        f.close()
