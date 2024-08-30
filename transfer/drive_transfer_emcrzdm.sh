#!/bin/bash
#################################################
# Author: Mallory Row
# Purpose: This drives transfer_emcrzdm.sh submitting
#          job to the dev_transfer queue
#################################################

set -x

HOMEevs_util=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS-util
LOGSevs_util=/lfs/h2/emc/ptmp/${USER}/evs_util_logs

now=$(date '+%Y%m%d%H%M%S')

# Get EVS COMPONENT
COMPONENT=${1:-"component"}
RUN=${2:-"run"}
VDATE=${3:-"vdate"}

# Make and work in the log directory
mkdir -p ${LOGSevs_util}

# Make sure we got all our passed agrument
if [ ${COMPONENT} = "component" ]; then
    echo "ERROR: Did not pass COMPONENT"
    exit 1
fi
if [ ${RUN} = "run" ]; then
    echo "ERROR: Did not pass RUN"
    exit 1
fi
if [ ${VDATE} = "vdate" ]; then
    echo "ERROR: Did not pass VDATE"
    exit 1
fi

# Submit to queue
qsub -q "dev_transfer" -A "VERF-DEV" -S /bin/bash -N transfer_emcrzdm_${COMPONENT}_${RUN}_v${VDATE} -o ${LOGSevs_util}/log_transfer_emcrzdm_${COMPONENT}_${RUN}_v${VDATE}_run${now}.out -e ${LOGSevs_util}/log_transfer_emcrzdm_${COMPONENT}_${RUN}_v${VDATE}_run${now}.out -l walltime=06:00:00 -l select=1:ncpus=1 -l debug=true -v COMPONENT=${COMPONENT},RUN=${RUN},VDATE=${VDATE} ${HOMEevs_util}/transfer/transfer_emcrzdm.sh
