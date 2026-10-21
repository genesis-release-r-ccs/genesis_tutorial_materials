for AApdb in `ls protein.AA_*pdb`;
do
CGpdb=${AApdb/AA/CG}
CGtop=${CGpdb/pdb/top}
../../spica-tools/bin/cg_spica map2cg $AApdb $CGpdb
../../spica-tools/bin/cg_spica ENM -v1 -aapdb $AApdb $CGpdb $CGtop  -dssp mkdssp
done
