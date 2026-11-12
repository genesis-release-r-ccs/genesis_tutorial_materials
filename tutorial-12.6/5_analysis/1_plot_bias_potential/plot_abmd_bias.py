#!/usr/bin/env python3
"""Plot ABMD bias profiles at fixed simulation-time intervals from GENESIS md.bp."""
import argparse
import re
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np

HEADER = re.compile(r'^#\s*STEP,\s*U\s+(\d+)\s+([-+\d.eE]+)')


def read_bp(filename):
    profiles = {}
    step = None
    xy = []

    def store():
        if step is not None and xy:
            values = np.array(xy, dtype=float)
            profiles[step] = (values[:, 0], values[:, 1])

    with open(filename, encoding='utf-8') as f:
        for raw in f:
            line = raw.strip()
            match = HEADER.match(line)
            if match:
                store()
                step = int(match.group(1))
                xy = []
            elif line and not line.startswith('#') and step is not None:
                parts = line.split()
                if len(parts) >= 2:
                    xy.append((float(parts[0]), float(parts[1])))
    store()
    return profiles


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('file', nargs='?', default='md.bp')
    p.add_argument('--dt', type=float, default=2.5, help='MD timestep in fs')
    p.add_argument('--interval', type=float, default=1.0, help='Plot interval in ns')
    p.add_argument('--output', default='abmd_bias.png')
    p.add_argument('--include-last', action='store_true', help='Also plot last snapshot')
    args = p.parse_args()
    if args.dt <= 0 or args.interval <= 0:
        p.error('--dt and --interval must be positive')

    profiles = read_bp(args.file)
    if not profiles:
        p.error('No # STEP, U blocks found')

    step_interval = args.interval * 1e6 / args.dt
    steps = sorted(profiles)
    # Pick the nearest saved snapshot to each requested time, but only if it
    # lies within half of the actual snapshot interval.
    gap = np.median(np.diff(steps)) if len(steps) > 1 else 0
    tolerance = max(gap / 2 + 1e-6, 1e-6)
    targets = np.arange(0, steps[-1] + tolerance, step_interval)
    chosen = []
    for target in targets:
        nearest = min(steps, key=lambda s: abs(s - target))
        if abs(nearest - target) <= tolerance and nearest not in chosen:
            chosen.append(nearest)
    if args.include_last and steps[-1] not in chosen:
        chosen.append(steps[-1])

    fig, ax = plt.subplots(figsize=(8, 5))
    for step in chosen:
        x, bias = profiles[step]
        ax.plot(x, bias, label=f'{step * args.dt / 1e6:g} ns')
    ax.set_xlabel('Collective variable (Å)', fontsize=16)
    ax.set_ylabel('Bias potential (kcal/mol)', fontsize=16)
    ax.tick_params(axis='both', labelsize=13)
    ax.legend(title='Simulation time')
    ax.grid(alpha=0.25)
    fig.tight_layout()
    fig.savefig(args.output, dpi=200)
    plt.close(fig)
    print(f'Saved {args.output} (steps: {chosen}; last step {steps[-1]}, '
          f'{steps[-1] * args.dt / 1e6:g} ns)')

if __name__ == '__main__':
    main()
