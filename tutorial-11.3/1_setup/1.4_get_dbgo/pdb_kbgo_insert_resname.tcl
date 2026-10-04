#!/usr/bin/tclsh
# changes GXXX resnames in KBGO pdb file to real resnames
# vmd -dispdev text -e pdb_kbgo_insert_resname.tcl -args all_atom.pdb coarse_grained.pdb
# output: kbgo pdb file with GXX resnames switched by the real resnames
###############################################################################################################
# procedures
###############################################################################################################
# inserts a string into a txt file name
# input: file name XXX.YYY
# input: str_add
# output: XXX_str_add.YYY
proc proc_file_name_insert_str {file_name str_add} {
	set list_file_name [split $file_name .]
	set file_name_add [lindex $list_file_name 0]_$str_add.[lindex $list_file_name 1]
	return $file_name_add
}

# return file name without a path
# input: file name with path (../../XXX/../filename.txt)
# output: name of last file in path (filename.txt)
proc proc_file_name_no_path {str_path} {
	set list_str_path [split $str_path /]
	return [lindex $list_str_path end]
}

###############################################################################################################
# script body
###############################################################################################################
# get pdb names
set PDB_NAME_AA [lindex $argv 0]
set PDB_NAME_KBGO [lindex $argv 1]

# open pdb
set mol_kbgo [mol new $PDB_NAME_KBGO]
set mol_aa [mol new $PDB_NAME_AA]

# change resname
set sel_kbgo_ca [atomselect $mol_kbgo "name CA"]
set sel_aa_ca [atomselect $mol_aa "name CA"]
foreach resname_aa [$sel_aa_ca get resname] resname_kbgo [$sel_kbgo_ca get resname] {
	set sel_kbgo_sing_res [atomselect $mol_kbgo "resname $resname_kbgo"]
	$sel_kbgo_sing_res set resname $resname_aa
	$sel_kbgo_sing_res delete
}
$sel_kbgo_ca delete
$sel_aa_ca delete

# write pdb
set pdb_no_path [proc_file_name_no_path $PDB_NAME_KBGO]
set pdb_new_name [proc_file_name_insert_str $pdb_no_path resname]
set sel_kbgo_all [atomselect $mol_kbgo "all"]
$sel_kbgo_all writepdb $pdb_new_name
$sel_kbgo_all delete

mol delete $mol_kbgo
mol delete $mol_aa
exit


