#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt

N_REP = 16                  # total number of replicas

fig, axes = plt.subplots(1, 1, figsize=(6, 4), constrained_layout=True, sharex=False, sharey=False)
for i_rep in range(N_REP):
    potential_data_fname = "./potential_energy_rep{0}.pot".format(i_rep + 1)
    pot_energy = np.loadtxt(potential_data_fname, usecols=(1))

    color_tmp = [i_rep / N_REP, 1 - i_rep / N_REP, 0]
    hist, edge = np.histogram(pot_energy, bins=50, density=True)
    X = 0.5 * (edge[:-1] + edge[1:])
    axes.plot(X, hist, "-", color=color_tmp)

    axes.set_xticks([-300 + 50 * j for j in range(6)])
    axes.set_xticklabels([-300 + 50 * j for j in range(6)], fontsize=12)
    axes.set_xlim(-310, -40)
    axes.set_xlabel(r"Potential Energy ($kcal/mol$)", fontsize=16)
    axes.set_yticks([0.02 * j for j in range(4)])
    axes.set_yticklabels(["0", "0.02", "0.04", "0.06"], fontsize=12)
    axes.set_ylim(0, 0.07)
    axes.set_ylabel("Probability", fontsize=16)

plt.savefig("potential_energy_temperature.png")

