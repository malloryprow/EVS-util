#!/bin/bash
#################################################
# Author: Mallory Row
# Purpose: This transfer final EVS plot tar files
#          to emcrzdm
#################################################

set -x

# Module Loads
module load rsync
module load prod_util

# Get EVS COMPONENT
COMPONENT=${1:-${COMPONENT:-"component"}}
RUN=${2:-${RUN:-"run"}}
VDATE=${3:-${VDATE:-"vdate"}}

# EVS Output Info
user_para=/lfs/h2/emc/ptmp/${USER}/evs/v2.0

# RZDM Info
webhost_id=${webhost_id:-$USER}
webhost=emcrzdm.ncep.noaa.gov
emcrzdm_dir=/home/people/emc/${webhost_id}/dev_tar_files

#### Transfer
COMPONENT_RUN_VDATE_web_dir=${emcrzdm_dir}/${COMPONENT}/${RUN}.${VDATE}
echo "Making ${COMPONENT_RUN_VDATE_web_dir} on ${webhost}"
ssh -q -l ${webhost_id} ${webhost} "mkdir -p ${COMPONENT_RUN_VDATE_web_dir}"
if [ $? -ne 0 ]; then
    echo "ERROR: Could not make ${COMPONENT_RUN_VDATE_web_dir} on ${webhost}"
    exit 1
fi
echo "Transfering ${user_para}/plots/${COMPONENT}/${RUN}.${VDATE}/*.tar to ${COMPONENT_RUN_VDATE_web_dir} on ${webhost}"
rsync -ahr -P ${user_para}/plots/${COMPONENT}/${RUN}.${VDATE}/*.tar ${webhost_id}@${webhost}:${COMPONENT_RUN_VDATE_web_dir}/.

#### Remove old directories
rm_VDATE=$($NDATE -48 ${VDATE}00 |cut -c1-8)
COMPONENT_RUN_rm_VDATE_web_dir=${emcrzdm_dir}/${COMPONENT}/${RUN}.${rm_VDATE}
echo "Removing ${COMPONENT_RUN_rm_VDATE_web_dir} on ${webhost}"
ssh -q -l ${webhost_id} ${webhost} "rm -r ${COMPONENT_RUN_rm_VDATE_web_dir}"
