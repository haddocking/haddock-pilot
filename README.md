# HADDOCK pilot machinery for running on HPC systems


### Introduction and concept

This repository contains simple example of a pilot machinery for running HADDOCK on a HPC system, using multiple nodes.
One pilot is started on each node, which runs as long as there is work to be done.

The pilot monitors the `01-TODO` directory for gzipped tar archives (`.tgz`) which are ready to execute HADDOCK runs.
When work is found, the pilot will move the archive to the `02-RUNNING` directory, touch in that directory a corresponding `.tgz.process` file to tell other pilots that this particular run is already being handled. The pilot then copies and unpacks the HADDOCK run into the `/tmp` directory and executes HADDOCK, running HADDOCK in node mode (i.e. the HADDOCK python process is started locally on the node, and the queue command defined in `run.cns` is simply `csh` (a version of HADDOCK configured to this end should thus be used). To use a full node, the number of queues in `run.cns` should be set to the number of available cores/threads on the node.

All computations thus occur locally on the node as the run directory should have been setup with relative paths (i.e. `./`).
Upon completion of the HADDOCK run, the pilot will archive the run, move it to the `04-RESULTS` directory and delete the local directory under `/tmp`. 
The input archive is moved from `02-RUNNING` to `03-DONE` and the `.process` file is deleted.

The pilot will then look for the next workload.
When no workloads are present anymore the pilot will stop.


### Relevant scripts


* `setup-run-node.csh`: An example script to prepare a docking run and modify parameters in `run.cns`. Edit it an adapt it to your needs. The script is currently configured to run the BM5 examples provided in the `DATA` directory, using true interface restraints defined at 5A. Call this script with as argument a list of complexes to pre-process (the structure of the complex directory should follow that of the HADDOCK-ready BM5 repository). E.g.: `./setup-run-node.csh DATA/1AY7`

* `haddock-pilot.csh`: The simple pilot script that will process the workload in alphabetical order as present in the `01-TODO` directory

* `haddock-pilot-size.csh`: The simple pilot script that will process the workload starting with the largest archives present in the `01-TODO` directory

* `run-mpi-haddock.sh`: An example script to manually launch the pilots on a set of nodes using `mpirun`. It expects a `hostfile` containing the list of nodes. The number of nodes given as argument to `-np` should match the number of nodes in the `hostfile`

* `run-pbs-haddock.sh`: An example script to launch the pilots using `mpirun` via the PBS batch system. The queue (`-q` argument), number of nodes (`-l nodes`) and number of processes per node (`ppn`) should be adapted to your needs. The hostfile for `mpirun` will be automatically created based on the allocated nodes.

* `run-slurm-haddock.sh`: An example script to launch the pilots using `srun` via the SLURM batch system. The number of nodes and processes (`-N` and `-n`) should match the number of requested nodes. The number of processes per node (`-c`) should match the number of cores/threads per node (in case of ful node allocation) and match the number of queues defined in `run.cns`. This script should be executed on the master nodes. The `srun` SLRUM command will allocate the nodes and start the pilots.


### Directory structure


The repository contains four directories:

* `01-TODO`: This is the directory where the ready to run archives should be placed. The pilots will monitor this directory.

* `02-RUNNING`: Directory containing the currently running jobs

* `03-DONE`: Directory containing the completed jobs (the ready to run archives)

* `04-RESULTS`: Directory containg the completed results archives

* `DATA`: Example data directory containing 8 complexes taken from the Docking Benchmark5, ranging in size from 184 to 211 residues.

