##### read pdb and remove center of mass
mol load pdb GO_1urp_A.pdb
set all [atomselect top all]
$all moveby [vecinvert [measure center $all weight mass]]

##### replace residue names with G1, G2, G3, ...
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
topology GO_1urp_A.top

segment PROT {
 first none
 last none
 pdb tmp.pdb
}
regenerate angles dihedrals
coordpdb tmp.pdb PROT

writepsf go_1urp.psf
writepdb go_1urp.pdb

