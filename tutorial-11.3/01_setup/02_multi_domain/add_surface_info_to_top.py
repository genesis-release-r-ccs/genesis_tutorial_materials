#!/usr/bin/env python3

def main():
    n_residues = 526

    residue_is_surface = [1 for i in range(n_residues)]

    # read surface information from files
    with open('FUS_surface_score.dat', 'r') as f:
        for line in f:
            parts = line.strip().split()
            residue_index = int(parts[0]) - 1
            surface_score = float(parts[1])
            if surface_score < 0.5:
                residue_is_surface[residue_index] = 0

    # edit residue names in the itp file
    with open('FUS_full_cg.itp', 'r') as f:
        lines = f.readlines()

    with open('FUS_full_cg_final.itp', 'w') as f:
        rw_atom = False
        for line in lines:
            if line.startswith(';') or line.strip() == '':
                f.write(line)
                continue
            if line.startswith('[ atoms ]'):
                rw_atom = True
                f.write(line)
                continue
            if rw_atom:
                if line.startswith('['):
                    rw_atom = False
                else:
                    parts = line.strip().split()
                    residue_index = int(parts[2]) - 1
                    if residue_is_surface[residue_index]:
                        line = line
                    else:
                        new_name = "i" + parts[3]
                        line = line[:11] + new_name + line[15:26] + new_name + line[30:]
            if line.startswith('[ cg_IDR_MPIPI_region ]'):
                f.write(line)
                f.write("   1    {0}".format(n_residues))
                break
            f.write(line)


if __name__ == '__main__':
    main()