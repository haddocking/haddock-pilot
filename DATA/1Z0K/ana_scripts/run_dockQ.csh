#!/bin/csh
#
source ~abonvin/haddock2.4/haddock_configure.csh
set WDIR=/home/abonvin/docking/BM5/1Z0K/ana_scripts
set refe=$WDIR/target.pdb
#
# Define the location of dockQ
#
setenv DOCKQ ~/haddock_git/DockQ-fortran-code/DockQ/DockQ.exe

echo "#stucture Fnat L-RMSD i-RMSD DockQ CAPRIquality DockQquality" >DockQ.dat

foreach i (`cat file.nam`)
  if ( -e $i.gz ) then
    gzip -dc $i.gz | sed -e 's/BB/CA/' > $i:t:r.tmp2
  else
    cat $i | sed -e 's/BB/CA/' > $i:t:r.tmp2
  endif
  echo $i |awk '{printf "%s ", $1}' >>DockQ.dat
  $DOCKQ $i:t:r.tmp2 $refe >tmp
  grep Fnat= tmp| awk '{printf "%s %s %s %s ", $2,$4,$6,$8}' >>DockQ.dat
  grep CAPRI tmp| grep fnat | awk '{printf "%s ", $NF}' >>DockQ.dat
  grep CAPRI tmp| grep Dock | awk '{print $NF}' >>DockQ.dat
  \rm $i:t:r.tmp2
  \rm tmp
end
