#!/usr/bin/bash

for irep in {1..16}; do
    cp 05_qval_residcg_analysis.inp tmp.inp
    sed -e "s/RUNID/ID$irep/g" -i tmp.inp
    /home/user/GENESIS/bin/qval_residcg_analysis tmp.inp
    rm -f tmp.inp
done

