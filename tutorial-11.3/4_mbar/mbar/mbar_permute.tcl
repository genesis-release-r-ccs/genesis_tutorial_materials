#!/usr/bin/tclsh
# generates multibasin permuted input for mbar_analysis
# input: .out files from multibasin exponential mixing simulations
# should include: num_basins, mix_temperature, basinenergy1, basinenergy2...
# param: IND_START_BASIN_ENE: column number in GENESIS output file in which BASIN_ENE inputs start (minus 2)
# output: n files (n=#replicas) in which GENESIS output enregies are calculated with parameters of all replicas with the multibasin mixing potential
# 1st col=#fr, from 2nd column: energies, parameters are in pre-determined order, as the input file 
##############################################################################################################
set NAME_FILE_IN files_md_out.txt
set IND_START_BASIN_ENE 12
set KB 0.00198719168260038
set SCRIPT_NAME mbar_multibasin_input_data
###############################################################################################################
# Procedures

# reads a txt file into a list
# input: file with 1-col entries
# output: list with each line as an element
proc proc_file_read_to_list {file_name} {
	set file_in [open $file_name r]
	set list_out {}
	while {[gets $file_in line]>=0} {
		lappend list_out $line
	}
	close $file_in
	return $list_out
}

# add a const num to a list
# input: list_tar
# input: NUM_ADD
# output: each el in list, NUM_ADD added to it
proc proc_list_add_const {list_tar num_add} {
	set list_ans {}
	foreach el $list_tar {
		set el_add [expr $el+$num_add]
		lappend list_ans $el_add
	}
	return $list_ans
}

# returns a list of elements from an index list (lindex for multiple)
# input: list_tar
# input: list_ind
# output: list with elements in indexes at list_ind 
proc proc_lindex_all_list {list_tar list_ind} {
	set list_el_all {}
	foreach ind $list_ind {
		lappend list_el_all [lindex $list_tar $ind]
	}
	return $list_el_all
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
# read input file
set list_files [proc_file_read_to_list $NAME_FILE_IN]

# extract temperature, numbasins, #fr from one of the files
# num_basins
set file_name_one [lindex $list_files 0]
set list_line_num_basins [exec grep num_basins $file_name_one]
set num_basins [lindex $list_line_num_basins 2]
# temperature
set list_line_temperature [exec grep temperature $file_name_one]
set temperature_sim [lindex $list_line_temperature 8]
# frames
set list_line_info [exec grep INFO $file_name_one]
set list_ind_info [lsearch -all $list_line_info "INFO:"]
set list_ind_fr [proc_list_add_const $list_ind_info 1]
set list_fr [proc_lindex_all_list $list_line_info $list_ind_fr]
set list_fr [lrange $list_fr 1 end]
# indexes for BASIN_ENE001~BASIN_ENE00X
set ind_start_basin_ene [expr $IND_START_BASIN_ENE+$num_basins]
set ind_end_basin_ene [expr $ind_start_basin_ene+$num_basins-1]
# set common file name
set file_out_name_common "run_permute.out"


# get mixing parameters for each file
set list_list_mix_param_all {}
# first element in the list is tmix, the rest are c1, c2 ...
foreach file_name $list_files {
	set list_mix_param_one {}
	set list_line_mix_t [exec grep mix_temperature $file_name]
	lappend list_mix_param_one [lindex $list_line_mix_t 5]
	set list_line_basin_energy [exec grep basinenergy $file_name]
	for {set i 2} {$i<[llength $list_line_basin_energy]} {incr i 3} {
		lappend list_mix_param_one [lindex $list_line_basin_energy $i]
	}
	lappend list_list_mix_param_all $list_mix_param_one
}

# read all basin energies
set ind_file 1
foreach file_name $list_files {
	set file_in [open $file_name r]
	set line_info_num 0
	set list_list_fr_basin_ene {}
	while {[gets $file_in line]>=0} {
		if {[string match *INFO* $line]==1} {
			if {$line_info_num<2} {
				# header line and 0-line
				incr line_info_num
			} else {
				# non-header lines: read data (starts from fr #1)
				set list_basin_ene [lrange $line $ind_start_basin_ene $ind_end_basin_ene]
				lappend list_list_fr_basin_ene $list_basin_ene
			}
		}
	}
	close $file_in
	# calculate permutations for each mixing-parameters set
	set list_list_condition_fr_e_total {}
	foreach list_mix_param $list_list_mix_param_all {
		set tmix [lindex $list_mix_param 0]
		set list_c [lrange $list_mix_param 1 end]
		set list_e_total_condition_1 {}
		foreach list_basin_ene $list_list_fr_basin_ene {
			# foreach fr
			set exp_sum 0
			foreach cx $list_c basin_ene_x $list_basin_ene {
				set exp_one [expr exp(-1/(1.0*$KB*$tmix)*($basin_ene_x+$cx))]
				set exp_sum [expr $exp_sum+$exp_one]
			}
			set e_total [expr -1*$KB*$tmix*log($exp_sum)]
			lappend list_e_total_condition_1 $e_total
			# in case of computing u_kl do here
		}
		lappend list_list_condition_fr_e_total $list_e_total_condition_1
	}
	set list_list_fr_condition_e_total [proc_list_invert_dimension $list_list_condition_fr_e_total]
	# write to file
	set file_out_name [proc_file_name_insert_str $file_out_name_common ${ind_file}]
	puts "writing file:\t$file_out_name"
	set file_out [open $file_out_name w]
	set ind_fr 1
	foreach list_condition_e_total $list_list_fr_condition_e_total {
		puts $file_out "$ind_fr\t$list_condition_e_total"
		incr ind_fr
	}
	close $file_out
	incr ind_file
}

#
exit






