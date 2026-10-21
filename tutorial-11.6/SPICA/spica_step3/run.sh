NPOPC=`grep "PH POPC" system.CG.pdb | wc -l`
NSOD=`grep "SOD SOD" system.CG.pdb | wc -l`
NCLA=`grep "CLA CLA" system.CG.pdb | wc -l`
NWat=`grep "TIP3" system.CG.pdb | wc -l`
## check the number of molecules
echo $NPOPC $NSOD $NCLA $NWat
echo "setup_gensis"


python3 ../../spica-tools/src/setup_gns.py  protein.CG_A.top 1 protein.CG_B.top 1 protein.CG_C.top 1 ../common/POPC.top $NPOPC ../common/SOD.top $NSOD ../common/CLA.top $NCLA  ../common/WAT.top $NWat  ../spica_protein_v2.prm system.CG.pdb
