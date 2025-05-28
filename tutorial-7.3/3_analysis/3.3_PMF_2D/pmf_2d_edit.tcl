#!/usr/bin/tclsh
# prepares .pmf file for plotting in matplotlib
# input: pmf.out file from pmf_analysis
# param: #
# output: pmf file written in the form readable by a plotting program
##############################################################################################################
set FILE_NAME_PMF pmf_2d_drms.out
set SCRIPT_NAME pmf_2d_edit
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

# removes all alphabet elements from list
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

# inverts a 2D list dimension
# input: list_list_dim1_dim2
# output: list_list_dim2_dim1
proc proc_list_invert_dimension {list_list_dim1_dim2} {
	set list_list_dim2_dim1 {}
	set list_tmp [lindex $list_list_dim1_dim2 0]
	set num_dim2 [llength $list_tmp]
	for {set ind 0} {$ind<$num_dim2} {incr ind} {
		set list_dim2 {}
		foreach list_dim1 $list_list_dim1_dim2 {
			lappend list_dim2 [lindex $list_dim1 $ind]
		}
		lappend list_list_dim2_dim1 $list_dim2
	}
	return $list_list_dim2_dim1
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

###############################################################################################################
# Script body
###############################################################################################################
# read data
set list_x [proc_file_read_col_n $FILE_NAME_PMF 0]
set list_y [proc_file_read_col_n $FILE_NAME_PMF 1]
set list_z [proc_file_read_col_n $FILE_NAME_PMF 2]

# divides into sections
set list_list_x {}
set list_list_y {}
set list_list_z {}
set list_x_section {}
set list_y_section {}
set list_z_section {}
foreach x $list_x y $list_y z $list_z {
	if {$x=={}} {
		lappend list_list_x $list_x_section
		lappend list_list_y $list_y_section
		lappend list_list_z $list_z_section
		set list_x_section {}
		set list_y_section {}
		set list_z_section {}
	} else {
		lappend list_x_section $x
		lappend list_y_section $y
		lappend list_z_section $z
	}
}

# calc x/y grid
set list_x_all [join $list_list_x]
set list_y_all [join $list_list_y]
set list_x_uniq [lsort -real -unique $list_x_all]
set list_y_uniq [lsort -real -unique $list_y_all]
# write
set file_grid_x [open grid_x.txt w]
set file_grid_y [open grid_y.txt w]
puts $file_grid_x $list_x_uniq
puts $file_grid_y $list_y_uniq
close $file_grid_x
close $file_grid_y


# sets Infinity values to max
# find max value
set list_z_all [join $list_list_z]
set list_z_number [proc_list_clean_alpha $list_z_all]
set max_z [proc_list_get_max $list_z_number]
# edit list_z
set list_list_z_num {}
foreach list_sec $list_list_z {
	set list_z_section {}
	foreach z $list_sec {
		if {$z=="Infinity"} {
			lappend list_z_section $max_z
		} else {
			lappend list_z_section $z
		}
	}
	lappend list_list_z_num $list_z_section 
}
set list_list_z_invert [proc_list_invert_dimension $list_list_z_num]
# write
set file_name_out [proc_file_name_insert_str $FILE_NAME_PMF plot]
set file_z_out [open $file_name_out w]
foreach list_z_num $list_list_z_invert {
	puts $file_z_out $list_z_num
}
close $file_z_out

#
exit


