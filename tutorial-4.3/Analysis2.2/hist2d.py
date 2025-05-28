#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt

# load data from file (use the 1st and 2nd columns)
x_data, y_data = np.loadtxt("output.tor", usecols=(1, 2), unpack=True)

# plot the 2d histogram with 72 bins on each dimension
plt.hist2d(x_data, y_data, bins=[72, 72], range=[[-180, 180], [-180, 180]], cmap="Reds")

# set aspect ratio to "equal"
plt.gca().set_aspect('equal', 'box')

# set ticks for x and y axis
plt.xticks([-180, -135, -90, -45, 0, 45, 90, 135, 180])
plt.yticks([-180, -135, -90, -45, 0, 45, 90, 135, 180])

# set x and y axis labels
plt.xlabel(r"$\phi$ ($^\circ$)")
plt.ylabel(r"$\psi$ ($^\circ$)")

# plot a colorlbar
plt.colorbar(label="frequency")

# save figure to file
plt.savefig("Ramachandran_plot.png", dpi=150)
