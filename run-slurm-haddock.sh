#!/bin/bash
#
cd /trinity/login/abonvin/docking/haddock-pilot

echo "Submitting HADDOCK slurm srun run at "`date`

# Pilot SLURM submission
srun -n 2 --ntasks-per-node=1  -c 96 -N 2 ./haddock-pilot.sh   >&srun.out &

echo "Ending HADDOCK slurm srun run at "`date`
