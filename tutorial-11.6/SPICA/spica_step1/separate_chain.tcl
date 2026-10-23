
set sel [atomselect top "all"]

set proA [atomselect top "segname PROA"]
set proB [atomselect top "segname PROB"]
set proC [atomselect top "segname PROC"]
$proA writepdb protein.AA_A.pdb
$proB writepdb protein.AA_B.pdb
$proC writepdb protein.AA_C.pdb
exit
