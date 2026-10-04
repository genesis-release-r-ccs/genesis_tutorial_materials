#!/bin/bash
for j in {1..16}; do
    sed "1d" ../6_MBAR/weight$j.dat > weight$j.dat
done
