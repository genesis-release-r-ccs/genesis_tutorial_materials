
## Directory Structure and File Conventions for `genesis_tutorial_materials`

### Directory layout

Each chapter lives in its own top-level directory named `tutorial-X.Y`, containing numbered subdirectories for each step. For example:

```
tutorial-3.2/
├── README.md
├── 01_setup/
├── 02_minimization/
├── 03_equilibration/
├── 04_production_run/
├── 05_analysis/
└── ...
```

Subdirectories are numbered with a two-digit prefix so that they sort correctly in any file browser or `ls` output. The exact names and number of steps will vary by chapter, but the numbering convention must be followed consistently.

A shared `common/` directory at the top level holds files used by more than one chapter (e.g. shared PDB files or topology files). Do not copy these files into individual chapter directories — reference the `common/` copy instead.

### Per-chapter README

Every `tutorial-X.Y/` directory must contain a `README.md` with at minimum:
- A link to the corresponding tutorial page on `mdgenesis.org`
- The prerequisite chapters, if any
- A one-line description of each subdirectory's purpose

### File content rules

**Do not commit DCD trajectory files.** They are large, binary, and almost never necessary as tutorial inputs. If you are unsure whether a DCD file is strictly required, open an issue for discussion before committing it.

Reference output files (small text files such as energy logs or RMSD data) are encouraged where they help Phase 3 reviewers verify that their results are correct.

For any large binary file that genuinely cannot be avoided (e.g. a pre-generated restart file), use **Git LFS** rather than committing it directly. Committing large binaries without LFS will cause the repository size to grow unboundedly.

### Checklist before opening a PR

- [ ] All subdirectories follow the `NN_step_name` numbering convention
- [ ] `README.md` is present and filled in
- [ ] No DCD files are included
- [ ] Any shared input files are placed in `common/` rather than duplicated
- [ ] Large binary files (if unavoidable) are tracked with Git LFS
