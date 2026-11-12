#!/usr/bin/env python3

import argparse
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm


def load_xyz_pmf(path):
    data = np.loadtxt(path)
    if data.ndim != 2 or data.shape[1] < 3:
        raise ValueError('Input PMF file must have at least 3 columns: x y pmf')

    x = data[:, 0]
    y = data[:, 1]
    z = data[:, 2]

    x_unique = np.unique(x)
    y_unique = np.unique(y)

    z_grid = np.full((len(y_unique), len(x_unique)), np.nan, dtype=float)
    x_index = {v: i for i, v in enumerate(x_unique)}
    y_index = {v: i for i, v in enumerate(y_unique)}

    for xv, yv, zv in zip(x, y, z):
        z_grid[y_index[yv], x_index[xv]] = zv

    return x_unique, y_unique, z_grid


def main():
    parser = argparse.ArgumentParser(
        description='Plot a 2D PMF from a 3-column file (x, y, pmf).'
    )
    parser.add_argument('input', help='Input PMF file with 3 columns: x y pmf')
    parser.add_argument('-o', '--output', default='PMF_dihedral.png',
                        help='Output PNG file name')
    parser.add_argument('--xlabel', default='Phi', help='X-axis label')
    parser.add_argument('--ylabel', default='Psi', help='Y-axis label')
    parser.add_argument('--cbar-label', default='PMF (kcal/mol)',
                        help='Colorbar label')
    parser.add_argument('--vmin', type=float, default=0.0,
                        help='Minimum PMF value for color scale')
    parser.add_argument('--vmax', type=float, default=4.0,
                        help='Maximum PMF value for color scale')
    parser.add_argument('--step', type=float, default=0.5,
                        help='Contour interval')
    parser.add_argument('--xmin', type=float, default=-180.0,
                        help='X-axis minimum')
    parser.add_argument('--xmax', type=float, default=180.0,
                        help='X-axis maximum')
    parser.add_argument('--ymin', type=float, default=-180.0,
                        help='Y-axis minimum')
    parser.add_argument('--ymax', type=float, default=180.0,
                        help='Y-axis maximum')
    args = parser.parse_args()

    plt.switch_backend('agg')
    plt.style.use('ggplot')
    plt.rcParams['font.size'] = 8
    plt.rcParams['pdf.fonttype'] = 42
    plt.rcParams['ps.fonttype'] = 42

    x, y, z = load_xyz_pmf(args.input)
    X, Y = np.meshgrid(x, y)

    # Do not draw values above vmax.
    z_plot = np.array(z, copy=True)
    z_plot[z_plot > args.vmax] = np.nan

    levels = np.arange(args.vmin, args.vmax + 0.5 * args.step, args.step)

    fig = plt.figure(figsize=(4, 3))
    c1 = plt.contourf(X, Y, z_plot, levels=levels, cmap=cm.jet)
    plt.contour(X, Y, z_plot, levels=levels, colors='k', linewidths=0.3)

    cbar = plt.colorbar(c1)
    cbar.set_label(args.cbar_label)

    plt.xlim([args.xmin, args.xmax])
    plt.ylim([args.ymin, args.ymax])
    plt.xticks([-180, -120, -60, 0, 60, 120, 180])
    plt.yticks([-180, -120, -60, 0, 60, 120, 180])
    plt.xlabel(args.xlabel)
    plt.ylabel(args.ylabel)
    plt.tight_layout()
    plt.savefig(args.output, dpi=200)
    plt.close(fig)


if __name__ == '__main__':
    main()
