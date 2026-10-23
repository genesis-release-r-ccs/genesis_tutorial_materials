#!/usr/bin/tclsh
# generates multibasin permuted target energy inputs for mbar_analysis
# input: .out files from multibasin exponential mixing simulations
# should include: num_basins, mix_temperature, basinenergy1, basinenergy2...
# input: file with target parameters sets in order of tmix, c1, c2, ... where each line in a set
# param: IND_START_BASIN_ENE: col# in GENESIS output file in which BASIN_ENE output starts (minus 2)
# output: n*m files (n=#replicas, m=#parameter sets), for each m (parameter set), n files are created, in file contains energy of simulation i with the parameter set j
##############################################################################################################
set NAME_FILE_IN_SIM_DATA files_md_out.txt
set NAME_FILE_IN_TARGETS files_targets.txt
set IND_START_BASIN_ENE 12
set KB 0.00198719168260038
set SCRIPT_NAME mbar_multibasin_input_target
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

# replaces all certain characters in string with a different char
# input: str_tar
# input: char_old
# input: char_new
# output: all char_old in str_tar replaced by char_new
proc proc_str_replace_char_by_char {str_tar char_old char_new} {
	set str_new $str_tar
	set pos 1
	while {$pos!=-1} {
		set pos [string first $char_old $str_new]
		if {$pos!=-1} {
			set str_new [string replace $str_new $pos $pos $char_new]
		}
	}
	return $str_new
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
###############################################################################################################
set list_files [proc_file_read_to_list $NAME_FILE_IN_SIM_DATA]

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
set file_out_name_common "run_target.out"

# read targets file
set list_list_targets [proc_file_read_to_list $NAME_FILE_IN_TARGETS]

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
	# create seperate files of the simulation data energies calculated with each target parameter set
	foreach list_param_target $list_list_targets {
		set tmix [lindex $list_param_target 0]
		set list_c [lrange $list_param_target 1 end]
		# convert c into strings
		set list_c_str {}
		foreach c $list_c {
			set c_minus [proc_str_replace_char_by_char $c - m]
			set c_period [proc_str_replace_char_by_char $c_minus . p]
			lappend list_c_str $c_period
		}
		# calculate energy of simulation for each param set
		set list_fr_e_total {}
		foreach list_basin_ene $list_list_fr_basin_ene {
			# foreach fr
			set exp_sum 0
			foreach cx $list_c basin_ene_x $list_basin_ene {
				set exp_one [expr exp(-1/(1.0*$KB*$tmix)*($basin_ene_x+$cx))]
				set exp_sum [expr $exp_sum+$exp_one]
			}
			set e_total [expr -1*$KB*$tmix*log($exp_sum)]
			lappend list_fr_e_total $e_total
		}
		# write to file
		# create file name
		set list_file_name_out_add [list $tmix $list_c_str]
		set list_file_name_out_add [join $list_file_name_out_add]
		set str_file_name_out_add [join $list_file_name_out_add "_"]
		set file_out_name [proc_file_name_insert_str $file_out_name_common ${ind_file}]
		puts "writing file:\t$file_out_name"
		set file_out [open $file_out_name w]
		set ind_fr 1
		foreach e_total $list_fr_e_total {
			puts $file_out "$ind_fr\t$e_total"
			incr ind_fr
		}
		close $file_out
	}
	incr ind_file
}

#
exit







