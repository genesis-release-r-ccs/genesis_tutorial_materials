#!/usr/bin/env python3
"""
Python script equivalent to:
  vmd -dispdev text -e write_gns_spica.tcl gns_spica.psf system.CG.pdb

Generates gns_spica.pdb by reading topology information (segname, resid, resname,
atomname) from the PSF file and coordinates/box dimensions from the PDB file.
"""

import sys
import argparse


def read_psf_atoms(psf_path):
    """Parse atom records from PSF file."""
    atoms = []
    with open(psf_path, "r") as f:
        in_natom = False
        for line in f:
            if "!NATOM" in line:
                in_natom = True
                continue
            if in_natom:
                line_str = line.strip()
                if not line_str:
                    break
                parts = line_str.split()
                # Columns: atom_id, segname, resid, resname, atomname, ...
                atoms.append({
                    "id": int(parts[0]),
                    "segname": parts[1],
                    "resid": int(parts[2]),
                    "resname": parts[3],
                    "atomname": parts[4],
                })
    return atoms


def read_pdb_coords(pdb_path):
    """Extract CRYST1 record and coordinate lines from input PDB file."""
    cryst1 = None
    coords = []
    with open(pdb_path, "r") as f:
        for line in f:
            if line.startswith("CRYST1"):
                cryst1 = line
            elif line.startswith(("ATOM  ", "HETATM")):
                x = float(line[30:38])
                y = float(line[38:46])
                z = float(line[46:54])
                coords.append((x, y, z))
    return cryst1, coords


def write_vmd_pdb(psf_atoms, coords, cryst1, output_path):
    """Write PDB matching VMD's writepdb formatting with PSF topology."""
    if len(psf_atoms) != len(coords):
        raise ValueError(
            f"Atom count mismatch: PSF has {len(psf_atoms)} atoms, "
            f"but PDB has {len(coords)} coordinates."
        )

    with open(output_path, "w") as out:
        if cryst1:
            out.write(cryst1 if cryst1.endswith("\n") else cryst1 + "\n")

        for atom, (x, y, z) in zip(psf_atoms, coords):
            atom_id = atom["id"] % 100000
            atom_name = atom["atomname"]
            if len(atom_name) < 4:
                atom_name_str = f" {atom_name:<3s}"
            else:
                atom_name_str = f"{atom_name:<4s}"

            res_str = f"{atom['resname']:4s}"[:4]
            chain = atom["segname"][0]
            resid = atom["resid"] % 10000
            segname = f"{atom['segname']:4s}"[:4]

            # VMD PDB output format:
            # ATOM  %5d %-4s %-4s%c%4d    %8.3f%8.3f%8.3f%6.2f%6.2f      %-4s
            line = (
                f"ATOM  {atom_id:5d} {atom_name_str:4s} {res_str}{chain}{resid:4d}    "
                f"{x:8.3f}{y:8.3f}{z:8.3f}  0.00  0.00      {segname}  \n"
            )
            out.write(line)

        out.write("END\n")


def main():
    parser = argparse.ArgumentParser(
        description="Convert PSF topology and PDB coordinates to VMD-style PDB (replaces VMD write_gns_spica.tcl)."
    )
    parser.add_argument(
        "psf",
        nargs="?",
        default="gns_spica.psf",
        help="Input PSF topology file (default: gns_spica.psf)",
    )
    parser.add_argument(
        "pdb",
        nargs="?",
        default="system.CG.pdb",
        help="Input PDB coordinate file (default: system.CG.pdb)",
    )
    parser.add_argument(
        "-o",
        "--output",
        default="gns_spica.pdb",
        help="Output PDB filename (default: gns_spica.pdb)",
    )

    args = parser.parse_args()

    psf_atoms = read_psf_atoms(args.psf)
    cryst1, coords = read_pdb_coords(args.pdb)

    write_vmd_pdb(psf_atoms, coords, cryst1, args.output)
    print(f"Successfully generated {args.output} from {args.psf} and {args.pdb}.")


if __name__ == "__main__":
    main()
