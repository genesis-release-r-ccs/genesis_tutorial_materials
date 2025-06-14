#!/bin/bash

# -----------------------------------------------
# Settings for Gaussian16
#
# --- Set the path for Gaussian ---
export g16root=/path/to/gaussian
export GAUSS_EXEDIR=$g16root/g16
export GAUSS_EXEBIN=$g16root/g16/g16
export PATH=$PATH:$GAUSS_EXEDIR
export LD_LIBRARY_PATH=${GAUSS_EXEDIR}:${LD_LIBRARY_PATH}

# --- Set the path for a scratch folder ---
scratch=/scr/$USER

# (optional) 
# --- Set a chkpoint file to read initial MOs ---
#initialchk='../path/to/initial.chk'
initialchk='../2_minimize/qmmm_min.0/gaussian.chk'

# -----------------------------------------------

QMINP=$1
QMOUT=$2
NSTEP=$3
MOL=${QMINP%.*}

# -----------------------------------------------
# Initial MO
#
# The initial MO is copied only for the 1st step 
# in MD.
#
if [ $NSTEP -eq 0 ] && [ -n "${initialchk}" ] && [ -e ${initialchk} ]; then
  cp ${initialchk} gaussian.chk
fi

# -----------------------------------------------
# Scratch folder settings
#
export GAUSS_SCRDIR=$scratch/$(mktemp -u $MOL.XXXX)
mkdir -p ${GAUSS_SCRDIR}

# -----------------------------------------------
# SMP parallel setting
#   - check if QM_NUM_THREADS is undefined.
#   - same as "test -v"
#
if [ -z "$QM_NUM_THREADS" ] && [ "${QM_NUM_THREADS:-A}" = "${QM_NUM_THREADS-A}" ]; then
  QM_NUM_THREADS=$OMP_NUM_THREADS
fi

TMP=$(mktemp tmp.XXXX)
echo "%NprocShared=${QM_NUM_THREADS}" >> $TMP
grep -v -i nproc $QMINP >> $TMP
mv $TMP $QMINP

# -----------------------------------------------
# Now exe g09 and create a formatted chk file
#
(time $GAUSS_EXEBIN < $QMINP) > ${QMOUT} 2>&1
formchk gaussian.chk gaussian.Fchk >& /dev/null

# -----------------------------------------------
# Remove unnecessary folder
#
rm -rf ${GAUSS_SCRDIR}

