#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt

pmf_data = np.loadtxt("./qval.pmf")

fig, ax = plt.subplots(1, 1, figsize=(6, 4), constrained_layout=True, sharex=False, sharey=False)
ax.plot(pmf_data[:, 0], pmf_data[:, 2], "r-")

ax.set_xticks([0.2 * i for i in range(6)])
ax.set_xticklabels(["0.0", "0.2", "0.4", "0.6", "0.8", "1.0"], fontsize=12)
ax.set_xlim(-0.02, 1.02)
ax.set_xlabel("Q value", fontsize=16)

ax.set_yticks([1 * i for i in range(6)])
ax.set_yticklabels([1 * i for i in range(6)], fontsize=12)
ax.set_ylim(-0.2, 4.2)
ax.set_ylabel("PMF (kcal/mol)", fontsize=16)

plt.savefig("qval_pmf.png", dpi=150)
