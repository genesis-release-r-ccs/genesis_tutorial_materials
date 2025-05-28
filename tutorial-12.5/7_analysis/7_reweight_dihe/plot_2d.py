#!/usr/bin/env python

from scipy.interpolate import griddata
from pylab import meshgrid,cm,imshow,contour,clabel,colorbar,axis,title,show,pcolor
from matplotlib.colors import LinearSegmentedColormap
import numpy as np
import matplotlib.mlab as ml
import matplotlib.pyplot as plt

# initial setting
plt.switch_backend('agg')
plt.style.use('ggplot')
#plt.rcParams['font.size'] = 14
# plt.rcParams['ps.useafm'] = True
# plt.rcParams['text.usetex'] = True
# plt.rcParams['pdf.fonttype'] = 42
# plt.rcParams['ps.fonttype'] = 42
#plt.rcParams['text.color'] = 'black'
#plt.rcParams['axes.labelcolor'] = 'black'
#plt.rcParams['xtick.color'] = 'black'
#plt.rcParams['ytick.color'] = 'black'
#plt.rcParams['axes.facecolor'] = '#cccccc'


def generate_cmap(colors):
    values = range(len(colors))
    vmax = np.ceil(np.max(values))
    color_list = []
    for v, c in zip(values, colors):
        color_list.append( ( v/ vmax, c) )
    return LinearSegmentedColormap.from_list('custom_cmap', color_list)

# load free energy landscape
x = np.loadtxt("./xi.dat")
y = np.loadtxt("./yi.dat")
z = np.loadtxt("./pmf_2d.dat")
X, Y = meshgrid(x, y)
interval = np.arange(0, 4.5, 0.5)

plt.figure(figsize=(4,3))

# set contour
cm = generate_cmap(["#0000ff", "#00ffff", "#00ff00", "#ffff00", "#ff0000"])
#cm = generate_cmap(["#0000ff", "#00ffff", "#00ff00", "#ffff00", "#ff4000"])
c1 = plt.contourf(X, Y, z, interval, cmap=cm)
#c1 = plt.contourf(X, Y, z, interval, cmap=cm.jet)
c2 = plt.contour(c1,interval,colors='k',linewidths=0.3)

# generate color bar
cbar = plt.colorbar(c1)
cbar.set_label("PMF (kcal/mol)")
#cbar.ax.yaxis.set_tick_params(color='k')

# plot
#plt.axes().set_aspect("equal")
plt.xlim([-180, 180])
plt.ylim([-180, 180])
plt.xlabel('Phi')
plt.ylabel('Psi')
plt.tight_layout()
plt.savefig("pmf_2d.pdf")
