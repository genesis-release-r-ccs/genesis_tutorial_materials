#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt

# load data from file (the 2nd column)
distance_data = np.loadtxt("output.dis", usecols=(1))

# plot the histogram
plt.hist(distance_data, bins=150, range=(0, 15))

# set axis ranges
plt.xlim(7, 13)
plt.ylim(0, 80)

# set labels
plt.xlabel(r"distance ($\AA$)")
plt.ylabel("frequency")

# save figure to png file
plt.savefig("distance_histogram.png", dpi=150)

