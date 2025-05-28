#!/usr/bin/tclsh
# writes requested chain of PDB
# vmd -dispdev text -e pdb_write_chain.tcl -args pdb_name.pdb chain_ID
###############################################################################################################
# procedures
# inserts a string into a txt file name
# input: file name XXX.YYY
# input: str_add
# output: XXX_str_add.YYY
proc proc_file_name_insert_str {file_name str_add} {
	set list_file_name [split $file_name .]
	set file_name_add [lindex $list_file_name 0]_$str_add.[lindex $list_file_name 1]
	return $file_name_add
}
###############################################################################################################
# 
set pdb_name [lindex $argv 0]
set chain_id [lindex $argv 1]
set mol_now [mol new $pdb_name]
set sel_chain [atomselect $mol_now "chain $chain_id and protein"]
set pdb_name_chain [proc_file_name_insert_str $pdb_name $chain_id]
$sel_chain writepdb $pdb_name_chain 
$sel_chain delete
mol delete $mol_now

#
exit
