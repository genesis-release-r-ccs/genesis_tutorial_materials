#!/bin/bash
#$ -cwd
#$ -V
#$ -q queue
#$ -pe ompi 1
#$ -S /bin/bash

. ../../1_setup/setpath.sh
${program_ana}/crd_convert crd_convert1.in > crd_convert1.log
${program_ana}/crd_convert crd_convert2.in > crd_convert2.log
${program_ana}/rmsd_analysis rmsd_analysis.in > rmsd_analysis.log


