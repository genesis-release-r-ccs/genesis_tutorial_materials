#!/usr/bin/env python3

# analyze the 5th column
i_col = 5

# use the list ene_data to store energy values
ene_data = []
with open("./energy.log", "r") as ene_file:
    for line in ene_file:
        ene_value = float(line.split()[i_col - 1])
        ene_data.append(ene_value)

# print length of the list
len_ene_data = len(ene_data)
print("Length of the energy list:", len_ene_data)

# find out the max/min
print("Maximum of column {0:>2d}: {1:>12.4f}".format(i_col, max(ene_data)))
print("Minimum of column {0:>2d}: {1:>12.4f}".format(i_col, min(ene_data)))

# calculate the average
ene_ave = sum(ene_data) / len_ene_data
print("Average of column {0:>2d}: {1:>12.4f}".format(i_col, ene_ave))

# calculate the standard deviation
ene_std = (sum((e - ene_ave)**2 for e in ene_data) / len_ene_data)**0.5
print("Standard deviation of column {0:>2d}: {1:>12.4f}".format(i_col, ene_std))
