#!/bin/bash
aa_pdb_open=../1.1_get_pdb/1urp_A.pdb
aa_pdb_closed=../1.1_get_pdb/2dri_A.pdb
cg_pdb_open=../1.3_edit_sbgo/GO_open.pdb
cg_pdb_closed=../1.3_edit_sbgo/GO_closed.pdb
param_sb_open=../1.2_get_sbgo/GO_1urp_A.param
param_sb_closed=../1.2_get_sbgo/GO_2dri_A.param
cg_pdb_resname_open=GO_open_resname.pdb
cg_pdb_resname_closed=GO_closed_resname.pdb
vmd -dispdev text -e pdb_kbgo_insert_resname.tcl -args ${aa_pdb_open} ${cg_pdb_open}
vmd -dispdev text -e pdb_kbgo_insert_resname.tcl -args ${aa_pdb_closed} ${cg_pdb_closed}
./DB_grotop.pl -param ${param_sb_open},${param_sb_closed} -pdb ${cg_pdb_resname_open},${cg_pdb_resname_closed} -out GO_DB.grotop
rm -f ${cg_pdb_resname_open}
rm -f ${cg_pdb_resname_closed}
