#!/usr/bin/env python3
"""
separate_chain.py

Separates individual protein chains from an all-atom PDB file into separate
PDB files (protein.AA_<chain>.pdb), replacing the VMD script `separate_chain.tcl`.

Usage:
    python3 separate_chain.py [PSF] <PDB>
    python3 separate_chain.py ../step5_input.pdb
    python3 separate_chain.py ../step5_input.psf ../step5_input.pdb
    python3 separate_chain.py --pdb ../step5_input.pdb --out-prefix protein.AA_
"""

import sys
import os
import argparse

# Standard and CHARMM amino acid residue names
AMINO_ACIDS = {
    'ALA', 'ARG', 'ASN', 'ASP', 'CYS', 'GLN', 'GLU', 'GLY', 'HIS', 'HSD',
    'HSE', 'HSP', 'ILE', 'LEU', 'LYS', 'MET', 'PHE', 'PRO', 'SER', 'THR',
    'TRP', 'TYR', 'VAL', 'CYX', 'GLH', 'ASH', 'ARN', 'LYN', 'HID', 'HIE',
    'HIP'
}

def parse_arguments():
    parser = argparse.ArgumentParser(
        description="Separate protein chains from a PDB file into individual PDB files."
    )
    parser.add_argument(
        'files',
        nargs='*',
        help="Input PDB file (and optional PSF file, e.g., $PSF $PDB matching VMD syntax)."
    )
    parser.add_argument(
        '-i', '--pdb',
        dest='pdb_file',
        help="Path to input PDB file."
    )
    parser.add_argument(
        '-o', '--out-prefix',
        dest='prefix',
        default='protein.AA_',
        help="Prefix for output PDB files (default: 'protein.AA_')."
    )
    parser.add_argument(
        '--segnames',
        nargs='+',
        dest='segnames',
        default=None,
        help="Optional list of specific segnames to extract (e.g., PROA PROB PROC)."
    )
    return parser.parse_args()


def determine_pdb_path(args):
    """Determine the input PDB file from arguments or default candidates."""
    if args.pdb_file:
        return args.pdb_file

    if args.files:
        # If files were passed positionally:
        # Could be "file.pdb" or "file.psf file.pdb"
        pdb_candidates = [f for f in args.files if f.lower().endswith('.pdb')]
        if pdb_candidates:
            return pdb_candidates[-1]
        # If no file ends with .pdb, take the last positional argument
        return args.files[-1]

    # Look for common default locations
    default_candidates = [
        '../step5_input.pdb',
        '../../step5_input.pdb',
        'step5_input.pdb'
    ]
    for candidate in default_candidates:
        if os.path.isfile(candidate):
            return candidate

    return None


def separate_chains(pdb_path, prefix="protein.AA_", target_segnames=None):
    if not os.path.isfile(pdb_path):
        print(f"Error: Input PDB file '{pdb_path}' not found.", file=sys.stderr)
        sys.exit(1)

    print(f"Reading PDB: {pdb_path}")
    cryst1_line = None
    chains = {}

    with open(pdb_path, 'r') as f:
        for line in f:
            if line.startswith('CRYST1') and cryst1_line is None:
                cryst1_line = line
            elif line.startswith(('ATOM  ', 'HETATM')):
                resname = line[17:20].strip()
                if resname not in AMINO_ACIDS:
                    continue

                segname = line[72:76].strip()
                chain_id = line[21].strip()

                # Filter if target segnames specified
                if target_segnames and segname not in target_segnames:
                    continue

                # Determine chain identifier for output filename
                # Handles CHARMM segnames like 'PROA' -> 'A', 'PRO1' -> '1', 'A' -> 'A'
                if segname.startswith('PRO') and len(segname) > 3:
                    chain_key = segname[3:]
                elif segname:
                    chain_key = segname
                elif chain_id:
                    chain_key = chain_id
                else:
                    chain_key = 'A'

                if chain_key not in chains:
                    chains[chain_key] = []
                chains[chain_key].append(line)

    if not chains:
        print("Warning: No protein residues found matching criteria.", file=sys.stderr)
        return

    # Write separate PDB files for each chain
    for chain_key in sorted(chains.keys()):
        out_filename = f"{prefix}{chain_key}.pdb"
        atom_lines = chains[chain_key]
        
        with open(out_filename, 'w') as out_f:
            if cryst1_line:
                out_f.write(cryst1_line)
            for atom_idx, line in enumerate(atom_lines, start=1):
                # Renumber atom serial (cols 7-11) starting from 1 (modulo 100000 for 5 cols)
                serial_str = f"{atom_idx % 100000:>5d}"
                renumbered_line = line[:6] + serial_str + line[11:]
                out_f.write(renumbered_line)
            out_f.write("END\n")

        print(f"  -> Generated {out_filename} ({len(atom_lines)} atoms)")

    print("Chain separation complete.")


def main():
    args = parse_arguments()
    pdb_path = determine_pdb_path(args)

    if not pdb_path:
        print(
            "Error: No input PDB file specified or found.\n"
            "Usage: python3 separate_chain.py [PSF] <PDB>",
            file=sys.stderr
        )
        sys.exit(1)

    separate_chains(pdb_path, prefix=args.prefix, target_segnames=args.segnames)


if __name__ == '__main__':
    main()
