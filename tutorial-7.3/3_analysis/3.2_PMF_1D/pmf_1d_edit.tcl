#!/usr/bin/tclsh
# edits PMF-1D from GENESIS to a plottable format
# input: timestep, pmf1, pmf2
# output: converts all Infinity values to the max value and sets minimum value to zero
##############################################################################################################
set FILE_NAME_PMF pmf_1d_drms.out
set SCRIPT_NAME pmf_1d_edit
###############################################################################################################
# Procedures

# read col-n from a file
# input: file_name
# input: col_n (from 0)
# output: list with all elements of col_n
proc proc_file_read_col_n {file_name col_n} {
	set file_in [open $file_name r]
	set list_col {}
	while {[gets $file_in line]>=0} {
		lappend list_col [lindex $line $col_n]
	}
	close $file_in
	return $list_col
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

# removes all alphabet elements from list
# input: list_tar
# output: list_tar with all alphabetic characters removes
proc proc_list_clean_alpha {list_tar} {
	set list_ans {}
	foreach el $list_tar {
		if {[string is alpha $el]==0} {
			lappend list_ans $el
		}
	}
	return $list_ans
}

# finds max val in list
# input: list_tar 
# output: max val in list_tar 
proc proc_list_get_max {list_tar} {
	set list_sort [lsort -real $list_tar]
	set val_max [lindex $list_sort end]
	return $val_max
} 

# finds min val in list
# input: list_tar 
# output: min val in list_tar 
proc proc_list_get_min {list_tar} {
	set list_sort [lsort -real $list_tar]
	set val_min [lindex $list_sort 0]
	return $val_min
} 

###############################################################################################################
# Script body
###############################################################################################################
# read data
set list_timestep [proc_file_read_col_n $FILE_NAME_PMF 0]
set list_pmf_1 [proc_file_read_col_n $FILE_NAME_PMF 1]
set list_pmf_2 [proc_file_read_col_n $FILE_NAME_PMF 2]

# open file to write
set file_name_out [proc_file_name_insert_str $FILE_NAME_PMF plot]
set file_out [open $file_name_out w]

# find min/max_val
set list_pmf_num_1 [proc_list_clean_alpha $list_pmf_1]
set list_pmf_num_2 [proc_list_clean_alpha $list_pmf_2]
set min_pmf_1 [proc_list_get_min $list_pmf_num_1]
set min_pmf_2 [proc_list_get_min $list_pmf_num_2]
set max_pmf_1 [proc_list_get_max $list_pmf_num_1]
set max_pmf_2 [proc_list_get_max $list_pmf_num_2]

# convert data and write
foreach timestep $list_timestep pmf_val_1 $list_pmf_1 pmf_val_2 $list_pmf_2 {
	if {$pmf_val_1=="Infinity"} { 
		set pmf_val_write_1 [expr $max_pmf_1-$min_pmf_1]
	} else {
		set pmf_val_write_1 [expr $pmf_val_1-$min_pmf_1]
	}
	if {$pmf_val_2=="Infinity"} { 
		set pmf_val_write_2 [expr $max_pmf_2-$min_pmf_2]
	} else {
		set pmf_val_write_2 [expr $pmf_val_2-$min_pmf_2]
	}
	puts $file_out "$timestep\t$pmf_val_write_1\t$pmf_val_write_2"
}
close $file_out

#
exit



