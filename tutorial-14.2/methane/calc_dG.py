#!/usr/bin/env python


import re, os, sys
import math


# calculate mean and standard error
def calc_stat(filename):
    f = open(filename)
    lines = f.readlines()
    f.close()
    final_line = lines[-1].split()
    # nblock: number of blocks used by mbar_analysis
    # mean: mean of free energy
    # se: standard error of free energy
    nblock = len(final_line)
    mean = 0.0
    se = 0.0
    for i in range(nblock):
        mean += float(final_line[i])
        se += float(final_line[i])*float(final_line[i])
    mean /= float(nblock)
    se /= float(nblock-1)
    se = se - mean*mean*float(nblock)/float(nblock-1)
    se = math.sqrt(se)
    se /= math.sqrt(nblock)
    return mean, se

# main routine
if __name__ == "__main__":
    dg_vacuum_mean, dg_vacuum_se = calc_stat("vacuum/fene.dat")
    dg_ligand_mean, dg_ligand_se = calc_stat("ligand/fene.dat")

    # calculate absolute binding free energy and its standard error
    dg = dg_vacuum_mean - dg_ligand_mean
    se = math.sqrt(dg_vacuum_se*dg_vacuum_se + dg_ligand_se*dg_ligand_se)

    print(" dG_vacuum   = %6.2f (%5.2f)" % (dg_vacuum_mean, dg_vacuum_se))
    print("-dG_ligand   = %6.2f (%5.2f)" % (-dg_ligand_mean, dg_ligand_se))
    print("----------------------------")
    print(" dG          = %6.2f (%5.2f)" % (dg, se))

