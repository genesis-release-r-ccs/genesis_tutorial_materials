NPOPC=`grep "PH POPC" pspica_conf.pdb | wc -l`
NSOD=`grep "SOD1 PSOD" pspica_conf.pdb | wc -l`
NCLA=`grep "CLA1 PCLA" pspica_conf.pdb | wc -l`
NPWat=`grep "W1 PWAT" pspica_conf.pdb | wc -l`
echo $NPOPC $NSOD $NCLA $NPWat
echo "setup_gensis"


python3 ../../spica-tools/src/setup_gns.py  protein.CG_A.top 1 protein.CG_B.top 1 protein.CG_C.top 1 ../common/PPOPC.top $NPOPC ../common/PSOD.top $NSOD ../common/PCLA.top $NCLA  ../common/PWAT.top $NPWat  ../pSPICA_protein.prm pspica_conf.pdb
