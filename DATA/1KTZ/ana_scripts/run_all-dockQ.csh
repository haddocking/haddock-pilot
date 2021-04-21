#!/bin/csh
#
source ~abonvin/haddock2.4/haddock_configure.csh
set WDIR=/home/abonvin/docking/BM5/1KTZ/ana_scripts
cd $1/structures/it1/water
$WDIR/run_dockQ.csh 
cd ..
$WDIR/run_dockQ.csh 
cd ../it0
$WDIR/run_dockQ.csh 
cd ../../../

exit:





