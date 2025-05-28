package require pbctools

mol load dcd "run_prod.dcd" psf "../1_setup/complex.psf"
set all [atomselect top all]
set nframe [molinfo top get numframes]
for {set i 0} {$i < $nframe} {incr i 1} {
	animate goto $i
	$all frame $i
	pbc wrap -center com -centersel protein -compound fragment
	$all moveby [vecinvert [measure center $all]]
}
animate write dcd "pbc_prod.dcd" skip 1 sel $all
mol delete all

exit
