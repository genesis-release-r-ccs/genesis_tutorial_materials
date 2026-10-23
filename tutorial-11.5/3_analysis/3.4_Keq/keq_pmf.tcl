#!/usr/bin/tclsh
# calculates Keq from 1D PMF
# input: 1D PMF file
# output: Keq
##############################################################################################################
set TEMP 260
set KB 0.001987191
set ELOG 2.71828188
set MIN_CV 1
set MAX_CV 10
set SCRIPT_NAME keq_pmf
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

# finds min val in list
# input: list_tar 
# output: min val in list_tar 
proc proc_list_get_min {list_tar} {
	set list_sort [lsort -real $list_tar]
	set val_min [lindex $list_sort 0]
	return $val_min
} 

# calc sum of all elements in list
# input: list_tar
# output: sum of all elements in list
proc proc_list_get_sum_elem {list_tar} {
	set ans_sum 0
	foreach el $list_tar {
		set ans_sum [expr $ans_sum+$el]
	}
	return $ans_sum
}
###############################################################################################################
# Script body
###############################################################################################################
# read data
set file_name_in [lindex $argv 0]
set list_bin [proc_file_read_col_n $file_name_in 0]
set list_pmf [proc_file_read_col_n $file_name_in 1]

# convert to historgram
set list_hist {}
foreach pmf $list_pmf {
	set hist_val [expr $ELOG**(-1.0*$pmf/($KB*$TEMP))]
	lappend list_hist $hist_val
}

# find min between two max
# trim ends
set list_bin_trim {}
set list_hist_trim {}
foreach bin $list_bin hist $list_hist {
	if {$bin>$MIN_CV && $bin<$MAX_CV} {
		lappend list_bin_trim $bin
		lappend list_hist_trim $hist
	}
}
set min_hist [proc_list_get_min $list_hist_trim]
set ind_min [lsearch $list_hist_trim $min_hist]
set min_bin [lindex $list_bin_trim $ind_min]

# calculate population in both halves
set list_hist_state_1 {}
set list_hist_state_2 {}
foreach bin $list_bin hist $list_hist {
	if {$bin<$min_bin} {
		lappend list_hist_state_1 $hist
	} else {
		lappend list_hist_state_2 $hist
	}
}
set sum_state_1 [proc_list_get_sum_elem $list_hist_state_1]
set sum_state_2 [proc_list_get_sum_elem $list_hist_state_2]
set keq [expr 1.0*$sum_state_1/$sum_state_2]
puts "Keq = $keq"

#
exit



