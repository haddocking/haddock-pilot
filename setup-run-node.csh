#!/bin/csh
#
source /trinity/login/abonvin/haddock_git/haddock2.4-node/haddock_configure.csh
set runext=ti5
set counter=0
set wdir=`pwd`
foreach i ($argv)
    set curdir=`pwd`
    set cplxname=`basename $i`
    #set cplxbase=$cplxname
    set cplxbase=1AY7
    set runname=${cplxname}-${runext}
    if (! -e 02-TODO/run1-$runname.tgz) then
        echo "HADDOCK_DIR=/trinity/login/abonvin/haddock_git/haddock2.4-node" >${i}/run.param
        echo "AMBIG_TBL=./ambig5.tbl" >>${i}/run.param
        echo "N_COMP=2" >>${i}/run.param
        echo "PDB_FILE1=./"${cplxbase}_r_u.pdb >>${i}/run.param
        echo "PDB_FILE2=./"${cplxbase}_l_u.pdb >>${i}/run.param
        #echo "CGPDB_FILE1=./"${cplxbase}_r_u_cg.pdb >>${i}/run.param
        #echo "CGPDB_FILE2=./"${cplxbase}_l_u_cg.pdb >>${i}/run.param
        echo "PROJECT_DIR=./" >>${i}/run.param
        echo "PROT_SEGID_1=A" >>${i}/run.param
        echo "PROT_SEGID_2=B" >>${i}/run.param
        echo "RUN_NUMBER=1-"$runname >>${i}/run.param
        #echo "CGTOAA_TBL=./cg_to_aa.tbl" >>${i}/run.param
        if ( -e ${i}/hbonds.tbl ) then
          echo "HBOND_FILE=hbonds.tbl" >>${i}/run.param
        endif
        echo "Launching run for "$i" "$runname
        cd $i
        haddock2.4
        \cp ligand* run1-$runname/toppar >&/dev/null
        cd run1-$runname
#        sed -e 's/ssub\ short/csh/g' \
#            -e 's/cpunumber_1=100/cpunumber_1=96/g' \
#            -e 's/structures_0=1000/structures_0=10000/g' \
#            -e 's/structures_1=200/structures_1=400/g' \
#            -e 's/anastruc_1=200/anastruc_1=400/g' \
#            -e 's/waterrefine=200/waterrefine=400/g' \
#            -e 's/cmrest=false/cmrest=true/g' \
        sed -e 's/hbonds_on=false/hbonds_on=true/g' run.cns > run.cns.node
            #-e 's/runana="cluster"/runana="none"/g' run.cns > run.cns.node
        \mv run.cns run.cns.store
        \mv run.cns.node run.cns
        cd ../
        tar cfz $curdir/02-TODO/run1-$runname.tgz run1-$runname
        rm -rf run1-$runname
        cd $curdir
    else 
        echo $i " already pre-processed"
    endif
end
