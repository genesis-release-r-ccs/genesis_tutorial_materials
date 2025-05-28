#!/usr/bin/env python

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
    ddG_complex_mean, ddG_complex_se = calc_stat("complex/fene.dat")
    ddG_ligand_mean, ddG_ligand_se = calc_stat("ligand/fene.dat")

    ddG_mean = ddG_complex_mean - ddG_ligand_mean
    ddG_se = math.sqrt(ddG_complex_se**2 + ddG_ligand_se**2)

    print(" ddG_complex = %6.2f (%5.2f)" % (ddG_complex_mean, ddG_complex_se))
    print("-ddG_ligand  = %6.2f (%5.2f)" % (-ddG_ligand_mean, ddG_ligand_se))
    print("----------------------------")
    print(" ddG         = %6.2f (%5.2f)" % (ddG_mean, ddG_se))

