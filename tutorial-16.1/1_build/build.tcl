mol load pdb 6NQ1.pdb
[atomselect top "resname ILE and name CD1"] set name CD
[atomselect top "resname HIS"             ] set resname HSD
set sel1 [atomselect top "protein and chain A"]
set sel2 [atomselect top "protein and chain B"]
$sel1 writepdb proa.pdb
$sel2 writepdb prob.pdb

package require psfgen
resetpsf
topology ../toppar/top_all36_prot.rtf
segment PROA {pdb proa.pdb}
segment PROB {pdb prob.pdb}

coordpdb proa.pdb PROA
coordpdb prob.pdb PROB

guesscoord

writepdb initial.pdb
writepsf initial.psf
exit
