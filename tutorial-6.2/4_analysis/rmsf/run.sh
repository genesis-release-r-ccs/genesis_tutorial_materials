#!/bin/bash

rm run1* run2*

$GENESIS_BIN_DIR/avecrd_analysis ./avecrd.inp > avecrd.out
$GENESIS_BIN_DIR/flccrd_analysis ./flccrd.inp > flccrd.out
