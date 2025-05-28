#!/bin/bash

rm rmsd.dat

$GENESIS_BIN_DIR/rmsd_analysis ./rmsd.inp > rmsd.log
