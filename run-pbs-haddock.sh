#!/bin/bash
#
#PBS -q long
#PBS -l nodes=2:ppn=48
#
cd /home/abonvin/docking/haddock-pilot
cat $PBS_NODEFILE >hostfile
echo "Starting HADDOCK MPI run at "`date`

mpirun -np 2 -bynode -machinefile ./hostfile ./haddock-pilot.sh

echo "Ending HADDOCK MPI run at "`date`

