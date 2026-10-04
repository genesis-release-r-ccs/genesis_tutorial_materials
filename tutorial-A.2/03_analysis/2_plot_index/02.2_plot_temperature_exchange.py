#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt

rep_parm_data = np.loadtxt("./T-REMD_repID-Temperature.log")

N_REP = 16                  # total number of replicas
n_row = 4                   # number of subplot rows
n_col = 4                   # number of subplot columns

fig, axes = plt.subplots(n_row, n_col, figsize=(n_col * 4, n_row * 3), constrained_layout=True, sharex=False, sharey=False)
X = rep_parm_data[:, 0]     # common X-axis data: time step
for i_ax in range(N_REP):
    m, n = i_ax // n_col, i_ax % n_col
    Y = rep_parm_data[:, i_ax + 1]  # Y-axis data: repID
    color_ax = [i_ax / N_REP, 1, 1 - i_ax / N_REP]
    axes[m, n].plot(X, Y, "-", c=color_ax)
    axes[m, n].set_xticks([20000000 * j for j in range(6)])
    axes[m, n].set_xticklabels([0, 2, 4, 6, 8, 10], fontsize=12)
    axes[m, n].set_xlim(0, 1e8)
    axes[m, n].set_xlabel(r"MD steps ($\times 10^7$)", fontsize=16)
    axes[m, n].set_yticks([j * 10 + 320 for j in range(16)])
    axes[m, n].set_yticklabels(["320", "", "", "", "360", "", "", "", "400", "", "", "", "440", "", "", ""], fontsize=12)
    axes[m, n].set_ylim(315, 475)
    axes[m, n].set_ylabel("Temperature (K)", fontsize=16)
    title_text = "Replica = {0}".format(i_ax + 1)
    axes[m, n].set_title(title_text, fontsize=16)

plt.savefig("Temperature_exchange_all.png")

