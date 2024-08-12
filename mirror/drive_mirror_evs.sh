#!/bin/bash
#################################################
# Author: Mallory Row
# Purpose: This drives mirror_evs.sh submitting
#          job to the dev_transfer queue
#################################################

set -x

HOMEevs_util=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS-util
LOGSevs_util=/lfs/h2/emc/ptmp/${USER}/evs_util_logs

# Get EVS COMPONENT
COMPONENT=${1:-"component"}

# Make and work in the log directory
mkdir -p ${LOGSevs_util}

# Submit to queue
qsub -q "dev_transfer" -A "VERF-DEV" -S /bin/bash -N mirror_evs_${COMPONENT} -o ${LOGSevs_util}/log_mirror_evs_${COMPONENT}.out -e ${LOGSevs_util}/log_mirror_evs_${COMPONENT}.out -l walltime=02:00:00 -l select=1:ncpus=1 -l debug=true -v COMPONENT=${COMPONENT} ${HOMEevs_util}/mirror/mirror_evs.sh
