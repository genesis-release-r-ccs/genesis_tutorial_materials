#!/bin/csh

# User-dedined parameters
set NUMDECOYS = 50

# Step1: Make peptide bond lists (tmp1 and tmp2)
grep -v " PRO " ../4_fix_errors_1/model1.pdb           | \
grep -e " HN " -e " N  " -e " C  " -e " O  " > tmp1

set NLINES = `wc -l tmp1 | awk '{print $1}'`
grep -A $NLINES ' C ' tmp1 | grep -B $NLINES ' HN ' > tmp2

# Step2: Make restraint lists (selection.dat and restraint.dat)
gfortran -o makelists.out ./template/makelists.f90
./makelists.out

# Step3: Create GENESIS control files and job scripts
set i = 1
while ($i <= $NUMDECOYS)
  echo "make control files for model $i"
  sed -e "s/MODELID/$i/g" ./template/INP >  INP$i
  less selection.dat                     >> INP$i
  less restraint.dat                     >> INP$i
  sed -e "s/MODELID/$i/g" ./template/job.sh > job$i.sh
  @ i = $i + 1
end
