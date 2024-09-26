#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS_beta5
STEP=plots
COMPONENT=cam

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output_beta5
cd /lfs/h2/emc/ptmp/${USER}/output_beta5

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
subcomponent_job=$1
plots_job=$2
if [ $subcomponent_job == firewx ]; then
    qsub ${drivers_dir}/jevs_cam_nam_firewxnest_${plots_job}_plots.sh
elif [ $subcomponent_job == ens ]; then
    qsub ${drivers_dir}/jevs_cam_href_${plots_job}_plots.sh
elif [ $subcomponent_job == det ]; then
    if [ $plots_job == grid2obs ]; then
        qsub -v vhr=$vhr ${drivers_dir}/jevs_cam_${plots_job}_plots_last31days.sh
        qsub -v vhr=$vhr ${drivers_dir}/jevs_cam_${plots_job}_plots_last90days.sh
    elif [ $plots_job == precip ]; then
        qsub -v vhr=$vhr ${drivers_dir}/jevs_cam_${plots_job}_plots_last31days.sh
        qsub -v vhr=$vhr ${drivers_dir}/jevs_cam_${plots_job}_plots_last90days.sh
    else
        qsub -v vhr=$vhr ${drivers_dir}/jevs_cam_${plots_job}_plots.sh
    fi
fi

