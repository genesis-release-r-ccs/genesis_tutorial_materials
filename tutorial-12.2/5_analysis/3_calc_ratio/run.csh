#!/bin/csh

grep " 1 >     2" ../../4_production/log | tail -1 >  log
grep " 2 >     3" ../../4_production/log | tail -1 >> log
grep " 3 >     4" ../../4_production/log | tail -1 >> log
grep " 4 >     5" ../../4_production/log | tail -1 >> log
grep " 5 >     6" ../../4_production/log | tail -1 >> log
grep " 6 >     7" ../../4_production/log | tail -1 >> log
grep " 7 >     8" ../../4_production/log | tail -1 >> log
grep " 8 >     9" ../../4_production/log | tail -1 >> log
grep " 9 >    10" ../../4_production/log | tail -1 >> log
grep "10 >    11" ../../4_production/log | tail -1 >> log
grep "11 >    12" ../../4_production/log | tail -1 >> log
grep "12 >    13" ../../4_production/log | tail -1 >> log
grep "13 >    14" ../../4_production/log | tail -1 >> log
