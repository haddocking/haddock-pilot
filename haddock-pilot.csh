#!/bin/csh
#
source /trinity/login/abonvin/haddock_git/haddock2.4-node/haddock_configure.csh

set datadir=/trinity/login/abonvin/haddock_git/haddock-pilot
echo "Starting HADDOCK pilot at "`date`" on "`hostname`
set seed=`date +%N`
set waittime=`awk -v min=0 -v max=20 -v seed=$seed 'BEGIN{srand(seed); print int(min+rand()*(max-min+1))}'`
sleep $waittime
while ( `ls $datadir/01-TODO/*.tgz | wc -l | awk '{print $1}'` > 0 ) 
    set todo=`ls $datadir/01-TODO/*.tgz |head -1`
    set runname=`basename $todo:r`
    set running=`echo $todo | sed -e 's/01-TODO/02-RUNNING/g'`
    if ( -e $todo) then
        if (! -e $running.process ) then
            touch $running.process
            \mv $todo $datadir/02-RUNNING
            cd /tmp
            tar xfz $running
            cd $runname
            echo "Starting HADDOCK for "$runname " at "`date`" on "`hostname`
            haddock2.4 >&haddock.out
            cd ..
            tar cfz $datadir/04-RESULTS/$runname.tgz $runname
            \rm -rf $runname
            \mv $running $datadir/03-DONE
            \rm $running.process
            echo "Finishing HADDOCK for "$runname " at "`date`" on "`hostname`
            cd $datadir
        endif
    endif
end
echo "Ending HADDOCK pilot at "`date`" on "`hostname`
