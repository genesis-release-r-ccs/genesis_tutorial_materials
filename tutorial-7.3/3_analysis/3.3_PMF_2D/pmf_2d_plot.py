#!/usr/bin/env python3

# from scipy.interpolate import griddata
from pylab import meshgrid,cm,imshow,contour,clabel,colorbar,axis,title,show,pcolor
from matplotlib.colors import LinearSegmentedColormap
import numpy as np
import matplotlib.mlab as ml
import matplotlib.pyplot as plt

# initial setting
plt.switch_backend('agg')
plt.style.use('ggplot')

def generate_cmap(colors):
    values = range(len(colors))
    vmax = np.ceil(np.max(values))
    color_list = []
    for v, c in zip(values, colors):
        color_list.append( ( v/ vmax, c) )
    return LinearSegmentedColormap.from_list('custom_cmap', color_list)

# load free energy landscape
x = np.loadtxt("./grid_x.txt")
y = np.loadtxt("./grid_y.txt")
z = np.loadtxt("./pmf_2d_drms_plot.out")
X, Y = meshgrid(x, y)
interval = np.arange(0, 9, 1)

plt.figure(figsize=(4,3))

# set contour
cm = generate_cmap(["#0000ff", "#00ffff", "#00ff00", "#ffff00", "#ff0000"])
c1 = plt.contourf(X, Y, z, interval, cmap=cm)
c2 = plt.contour(c1,interval,colors='k',linewidths=0.3)

# generate color bar
cbar = plt.colorbar(c1)
cbar.set_label("PMF (kcal/mol)")

# plot
plt.xticks(np.arange(0,16,3.0))
plt.yticks(np.arange(0,16,3.0))
plt.xlabel('dRMS$_{Closed}$')
plt.ylabel('dRMS$_{Open}$')
plt.tight_layout()
plt.savefig("pmf_2d_drms.png",dpi=300)

