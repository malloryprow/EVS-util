#!/bin/bash
#################################################
# Author: Mallory Row
# Purpose: This mirrors between WCOSS2 machines
#          Cactus and Dogwood for the EVS
#          parallel(s).
#################################################

set -x

# Module Loads
module load rsync

# Get EVS COMPONENT
COMPONENT=${1:-${COMPONENT:-"component"}}

# EVS Output Info
user_para=/lfs/h2/emc/vpppg/noscrub/${USER}/evs/v2.0

# Machine Info
#### Production Machine
export prod=$(cat /lfs/h1/ops/prod/config/prodmachinefile | grep "primary:" | sed -e 's/primary://g')
export prod_letter=$(echo $prod | cut -c 1-1)
#### Development Machine
export dev=$(cat /lfs/h1/ops/prod/config/prodmachinefile | grep "backup:" | sed -e 's/backup://g')
export dev_letter=$(echo $dev | cut -c 1-1)
#### Production and Development Machine Transfer Host
if [ $prod_letter = c ] && [ $dev_letter = d ]; then
    export prod_transfer_host="cdxfer.wcoss2.ncep.noaa.gov"
    export dev_transfer_host="ddxfer.wcoss2.ncep.noaa.gov"
elif [ $prod_letter = d ] && [ $dev_letter = c ]; then
    export prod_transfer_host="ddxfer.wcoss2.ncep.noaa.gov"
    export dev_transfer_host="cdxfer.wcoss2.ncep.noaa.gov"
else
    echo "ERROR: Unknown hostnames"
    exit 1
fi
#### Current Machine
export cur=$HOSTNAME
export cur_letter=$(echo $HOSTNAME | cut -c 1-1)
#### Other Machine
if [ $cur_letter = c ]; then
    export other_transfer_host="ddxfer.wcoss2.ncep.noaa.gov"
elif [ $cur_letter = d ]; then
    export other_transfer_host="cdxfer.wcoss2.ncep.noaa.gov"
fi

# Set STEPS that are run for each COMPONENT
if [ $COMPONENT = analyses ]; then
    STEPS="stats"
elif [ $COMPONENT = aqm ]; then
    STEPS="prep stats"
elif [ $COMPONENT = cam ]; then
    STEPS="prep stats"
elif [ $COMPONENT = global_det ]; then
    STEPS="prep stats"
elif [ $COMPONENT = global_ens ]; then
    STEPS="prep stats"
elif [ $COMPONENT = mesoscale ]; then
    STEPS="stats"
elif [ $COMPONENT = narre ]; then
    STEPS="stats" 
elif [ $COMPONENT = nfcens ]; then
    STEPS="prep stats"
elif [ $COMPONENT = rtofs ]; then
    STEPS="prep stats"
elif [ $COMPONENT = subseasonal ]; then
    STEPS="prep stats"
elif [ $COMPONENT = wafs ]; then
    STEPS="stats"
else
    echo "ERROR: $COMPONENT not a known component"
    exit 1
fi

#### Transfer emc.vpppg parallel [$emcvpppg_para]; from dev to prod
for STEP in $STEPS; do
    rsync -ahr -P ${user_para}/${STEP}/${COMPONENT}/* ${other_transfer_host}:${user_para}/${STEP}/${COMPONENT}/.
done
