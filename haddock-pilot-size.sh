#!/bin/csh
#
# Setup HADDOCK environment
source /trinity/login/abonvin/haddock_git/haddock2.4-node/haddock_configure.csh

# Location of data directory - change if needed
export datadir=$PWD

# Start pilot, and wait a short random time
echo "Starting HADDOCK pilot at "`date`" on "`hostname`
export waittime=`echo ${RANDOM} | awk '{printf "%d\n",$1/2000}'`
sleep $waittime

# Loop over workloads
while [ `ls $datadir/01-TODO/*.tgz | wc -l | awk '{print $1}'` > 0 ]; do 
    # Start with largest systems 
    export todo=`ls -al $datadir/01-TODO/*tgz |sort -nrk5 |awk '{print $NF}' |head -1`
    export runname=`basename $todo:r`
    export running=`echo $todo | sed -e 's/01-TODO/02-RUNNING/g'`
    if [ -e $todo]; then
        if [! -e $running.process ; then
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
        fi
    fi
done
echo "Ending HADDOCK pilot at "`date`" on "`hostname`
