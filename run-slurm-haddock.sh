#!/bin/bash
#
cd /trinity/login/abonvin/haddock_git/haddock-pilot

echo "Submitting HADDOCK slurm srun run at "`date` 

# Pilot SLURM submission
srun -n 2 --ntasks-per-node=1  -c 96 -N 2 ./haddock-pilot-size.csh 

echo "Ending HADDOCK slurm srun run at "`date`
