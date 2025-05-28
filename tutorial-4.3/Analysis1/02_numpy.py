#!/usr/bin/env python3

import numpy as np

# analyze the 5th column
i_col = 5

# use array ene_data to store energy values
ene_data = np.loadtxt("./energy.log", usecols=i_col - 1)

# print length of the list
len_ene_data = ene_data.size
print("Length of the energy list:", len_ene_data)

# find out the max/min
print("Maximum of column {0:>2d}: {1:>12.4f}".format(i_col, ene_data.max()))
print("Minimum of column {0:>2d}: {1:>12.4f}".format(i_col, ene_data.min()))

# calculate the average
ene_ave = ene_data.mean()
print("Average of column {0:>2d}: {1:>12.4f}".format(i_col, ene_ave))

# calculate the standard deviation
ene_std = ene_data.std()
print("Standard deviation of column {0:>2d}: {1:>12.4f}".format(i_col, ene_std))
