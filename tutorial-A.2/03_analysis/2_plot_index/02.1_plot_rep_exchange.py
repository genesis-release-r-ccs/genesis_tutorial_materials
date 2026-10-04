#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt

parm_rep_data = np.loadtxt("./T-REMD_parmID-repID.log")

N_REP = 16                  # total number of replicas
n_row = 4                   # number of subplot rows
n_col = 4                   # number of subplot columns

fig, axes = plt.subplots(n_row, n_col, figsize=(n_col * 4, n_row * 3), constrained_layout=True, sharex=False, sharey=False)
X = parm_rep_data[:, 0]     # common X-axis data: time step
for i_ax in range(N_REP):
    m, n = i_ax // n_col, i_ax % n_col
    Y = parm_rep_data[:, i_ax + 1]  # Y-axis data: repID
    axes[m, n].plot(X, Y, ".", c="red")
    axes[m, n].set_xticks([20000000 * j for j in range(6)])
    axes[m, n].set_xticklabels([0, 2, 4, 6, 8, 10], fontsize=12)
    axes[m, n].set_xlim(0, 1e8)
    axes[m, n].set_xlabel(r"MD steps ($\times 10^7$)", fontsize=16)
    axes[m, n].set_yticks([j for j in range(1, 17)])
    axes[m, n].set_yticklabels(["", "", "", "4", "", "", "", "8", "", "", "", "12", "", "", "", "16"], fontsize=12)
    axes[m, n].set_ylim(0, 17)
    axes[m, n].set_ylabel("Replica ID", fontsize=16)
    title_text = "Temperature = {0} K".format(i_ax * 10 + 320)
    axes[m, n].set_title(title_text, fontsize=16)

plt.savefig("Replica_exchange_all.png")

