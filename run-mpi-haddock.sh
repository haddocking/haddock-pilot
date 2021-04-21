#!/bin/bash
#
cd /trinity/login/abonvin/docking/haddock-pilot
echo "Starting HADDOCK MPI run at "`date`
/trinity/login/clgeng/anaconda3/bin/mpirun -np 5 --map-by node -machinefile ./hostfile ./haddock-pilot-size.csh
echo "Ending HADDOCK MPI run at "`date`
