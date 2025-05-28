#!/usr/bin/tclsh
# edits a .pdb file for KBGo and creates .psf
# vmd -dispdev text -e edit_sbgo.tcl -args pdb_name.pdb open/closed
# output: pdb/psf files in kbgo (res names G1, G2, ..., creates pdb/psf files, center at the COM)
###############################################################################################################
# preocedures
###############################################################################################################
# return file name without a path
# input: file name with path (../../XXX/../filename.txt)
# output: name of last file in path (filename.txt)
proc proc_file_name_no_path {str_path} {
	set list_str_path [split $str_path /]
	return [lindex $list_str_path end]
}

# inserts a string into a txt file name
# input: file name XXX.YYY
# input: str_add
# output: XXX_str_add.YYY
proc proc_file_name_insert_str {file_name str_add} {
	set list_file_name [split $file_name .]
	set file_name_add [lindex $list_file_name 0]_$str_add.[lindex $list_file_name 1]
	return $file_name_add
}

# replaces ending of a file
# input: str_full: XXX.YYY
# param: new ending: ZZZ
# output: XXX.ZZZ
proc proc_str_new_end {str_full END_NEW} {
	set list_str [split $str_full .]
	set str_no_end [lindex $list_str 0]
	set str_new_end "${str_no_end}.${END_NEW}"
	return $str_new_end
}

###############################################################################################################
# script body
###############################################################################################################
# read pdb
set PDB_NAME [lindex $argv 0]
set CONF_NAME [lindex $argv 1]
set TOP_NAME [regsub ".pdb" $PDB_NAME ".top"]

mol load pdb $PDB_NAME

# replace residue names with G1, G2, G3, ...
set sel_all [atomselect top "all"]
set list_residue [lsort -unique -integer [$sel_all get resid]]
foreach i $list_residue {
    set resname_go [format "G%d" $i]
    set res [atomselect top "resid $i" frame all]
    $res set resname $resname_go
}

$sel_all writepdb tmp.pdb

# generate PSF and PDB files
package require psfgen
resetpsf
topology $TOP_NAME

segment PROT {
 first none
 last none
 pdb tmp.pdb
}
regenerate angles dihedrals
coordpdb tmp.pdb PROT

# move system origin to center of mass
$sel_all moveby [vecinvert [measure center $sel_all weight mass]]

# write psf and pdb files
set pdb_name_new "GO_${CONF_NAME}.pdb"
set psf_name_new "GO_${CONF_NAME}.psf"
writepsf $psf_name_new
writepdb $pdb_name_new

$sel_all delete
exec rm -f tmp.pdb
exit

