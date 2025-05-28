#!/usr/bin/env python

from pylab import meshgrid,cm,imshow,contour,clabel,colorbar,axis,title,show,pcolor
import numpy as np
import matplotlib.pyplot as plt

# initial setting
plt.switch_backend('agg')
plt.style.use('ggplot')
plt.rcParams['font.size'] = 8
plt.rcParams['pdf.fonttype'] = 42
plt.rcParams['ps.fonttype'] = 42
plt.figure(figsize=(4,3))

# load free energy landscape
x = np.loadtxt("./xi.dat")
y = np.loadtxt("./yi.dat")
z = np.loadtxt("./pmf_2d.dat")
X, Y = meshgrid(x, y)
interval = np.arange(0, 4.5, 0.5)

# set contour
c1 = plt.contourf(X, Y, z, interval, cmap=cm.jet)
c2 = plt.contour(c1, interval, colors='k', linewidths=0.3)

# generate color bar
cbar = plt.colorbar(c1)
cbar.set_label("PMF (kcal/mol)")

# plot
plt.xlim([-180, 180])
plt.ylim([-180, 180])
plt.xticks([-180, -120, -60, 0, 60, 120, 180])
plt.yticks([-180, -120, -60, 0, 60, 120, 180])
plt.xlabel('Phi')
plt.ylabel('Psi')
plt.tight_layout()
plt.savefig("PMF_dihedral.png")
