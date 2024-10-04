#!/bin/bash
#################################################
# Author: Mallory Row
# Purpose: This drives transfer_hpss.sh submitting
#          job to the dev_transfer queue
#################################################

set -x

HOMEevs_util=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS-util
LOGSevs_util=/lfs/h2/emc/ptmp/${USER}/evs_util_logs

now=$(date '+%Y%m%d%H%M%S')

# Get EVS COMPONENT
COMPONENT=${1:-"component"}
YYYYmm=${2:-"YYYYmm"}

# Make and work in the log directory
mkdir -p ${LOGSevs_util}

# Make sure we got all our passed agrument
if [ ${COMPONENT} = "component" ]; then
    echo "ERROR: Did not pass COMPONENT"
    exit 1
fi
if [ ${YYYYmm} = "YYYYmm" ]; then
    echo "ERROR: Did not pass YYYYmm"
    exit 1
fi

# Submit to queue
qsub -q "dev_transfer" -A "VERF-DEV" -S /bin/bash -N transfer_hpss_${COMPONENT}_${YYYYmm} -o ${LOGSevs_util}/log_transfer_hpss_${COMPONENT}_${YYYYmm}_run${now}.out -e ${LOGSevs_util}/log_transfer_hpss_${COMPONENT}_${YYYYmm}_run${now}.out -l walltime=06:00:00 -l select=1:ncpus=1 -l debug=true -v COMPONENT=${COMPONENT},YYYYmm=${YYYYmm} ${HOMEevs_util}/transfer/transfer_hpss.sh
