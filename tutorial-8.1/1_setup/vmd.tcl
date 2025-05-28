mol load pdb 2QMT.pdb
set sel [atomselect top "chain A and protein"] 
$sel writepdb tmp.pdb
exit
