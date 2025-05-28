##### read pdb
mol load pdb GO_1pgb.pdb

##### replace residue names with G1, G2, G3, ...
set all [atomselect top all]
set residue_list [lsort -unique [$all get resid]]
foreach i $residue_list {
    set resname_go [format "G%d" $i]
    set res [atomselect top "resid $i" frame all]
    $res set resname $resname_go
}

$all writepdb tmp.pdb

##### generate PSF and PDB files
package require psfgen
resetpsf
topology GO_1pgb.top

segment PROT {
 first none
 last none
 pdb tmp.pdb
}
regenerate angles dihedrals
coordpdb tmp.pdb PROT

# move system origin to center of mass
$all moveby [vecinvert [measure center $all weight mass]]

# write psf and pdb files
writepsf go.psf
writepdb go.pdb

exit
