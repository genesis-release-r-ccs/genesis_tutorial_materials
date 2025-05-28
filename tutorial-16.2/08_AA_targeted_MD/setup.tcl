##### save the last frame
mol load pdb ../06_AA_build/open.pdb psf ../06_AA_build/open.psf
mol addfile md.dcd
animate goto end
set sel [atomselect top all] 
$sel writepdb targeted_last.pdb 
mol delete all

##### read pdb
mol load pdb targeted_last.pdb
mol load pdb ../06_AA_build/CG_open2.pdb

##### calculate the shift matrix using the CA atoms positions
set base_shifted [atomselect 1 "name CA"]
set base_original [atomselect 2 "name CA"]
set matrix [measure fit $base_shifted $base_original]

##### move the  targeted_last.pdb structure 
set shifted_molecule [atomselect 1 "all"]
$shifted_molecule move $matrix
$shifted_molecule writepdb targeted_shifted.pdb

exit
