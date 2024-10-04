#!/bin/bash
#################################################
# Author: Mallory Row
# Purpose: This tars up final stat files for HPSS
#################################################

set -x

# Module Loads
module load prod_util

# Get EVS COMPONENT
COMPONENT=${1:-${COMPONENT:-"component"}}
YYYYmm=${2:-${YYYYmm:-"YYYYmm"}}
USER=emc.vpppg
# EVS Output Info
user_para=/lfs/h2/emc/vpppg/noscrub/$USER/evs/v2.0

# HPSS Info
user_para_hpss_dir=/NCEPDEV/emc-global/5year/$USER/evs_parallel

#### Transfer
cd ${user_para}/stats/${COMPONENT}
htar -cvf *${YYYYmm}* ${user_para_hpss_dir}/stats/${COMPONENT}/${YYYYmm}.tar
