#!/bin/bash
#$ -cwd
#$ -V
#$ -q queue
#$ -pe ompi 1
#$ -S /bin/bash

. ../../1_setup/setpath.sh

${program_ana}/rpath_generator INP > log
