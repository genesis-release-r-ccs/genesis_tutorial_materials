#!/bin/sh

for i in {1..2}; do

for j in {1..24}; do

cat << EOF > run${i}_rep${j}.sh
#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -pe ompi28 28
#$ -q all.q
#$ -j y

export OMP_NUM_THREADS=4
spdyn=\$GENESIS_BIN_DIR/spdyn

mpirun -machinefile \$TMP/machines -npernode 8 -n 8 \$spdyn run${i}_rep${j}.inp > output/run${i}_rep${j}.out
EOF

done

done
