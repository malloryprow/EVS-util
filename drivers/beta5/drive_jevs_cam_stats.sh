#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS_beta5
STEP=stats
COMPONENT=cam

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output_beta5
cd /lfs/h2/emc/ptmp/${USER}/output_beta5

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
subcomponent_job=$1
stats_job=$2
if [ $subcomponent_job == firewx ]; then
    qsub -v vhr=$vhr ${drivers_dir}/jevs_cam_nam_firewxnest_${stats_job}_stats.sh
elif [ $subcomponent_job == ens ]; then
    if [ $stats_job == radar ]; then
        qsub -v vhr=$vhr ${drivers_dir}/jevs_cam_href_${stats_job}_stats.sh
    elif [ $stats_job == severe ]; then
        qsub -v vhr=$vhr ${drivers_dir}/jevs_cam_href_${stats_job}_stats.sh
    else
        qsub ${drivers_dir}/jevs_cam_href_${stats_job}_stats.sh
    fi
elif [ $subcomponent_job == det ]; then
    models="hireswarw hireswarwmem2 hireswfv3 hrrr namnest"
    for model in ${models}; do
        qsub -v vhr=$vhr ${drivers_dir}/jevs_cam_${model}_${stats_job}_stats.sh
    done
fi
