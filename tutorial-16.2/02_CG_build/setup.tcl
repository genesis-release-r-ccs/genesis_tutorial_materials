##### read pdb
mol load pdb GO_open.pdb
mol load pdb col_best_001_edited.pdb  

##### calculate the shift matrix using the CA atoms positions
set base_shifted [atomselect 0 "name CA"]
set base_original [atomselect 1 "name CA"]
set matrix [measure fit $base_shifted $base_original]

##### move the  GO_open.pdb structure 
set shifted_molecule [atomselect 0 "all"]
$shifted_molecule move $matrix

##### replace residue names with G1, G2, G3, ...
set residue_list [lsort -unique [$shifted_molecule get resid]]
foreach i $residue_list {
    set resname_go [format "G%d" $i]
    set res [atomselect 0 "resid $i" frame all]
    $res set resname $resname_go
}

$shifted_molecule writepdb tmp.pdb

##### generate PSF and PDB files
package require psfgen
resetpsf
topology GO_open.top

segment PROT {
 first none
 last none
 pdb tmp.pdb
}
regenerate angles dihedrals
coordpdb tmp.pdb PROT

# write psf and pdb files
writepsf go.psf
writepdb go.pdb

exit
