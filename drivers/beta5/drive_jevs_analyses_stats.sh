#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS_beta5
STEP=stats
COMPONENT=analyses

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output_beta5
cd /lfs/h2/emc/ptmp/${USER}/output_beta5

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
qsub -v vhr=$vhr ${drivers_dir}/jevs_analyses_rtma_grid2obs_stats.sh
qsub -v vhr=$vhr ${drivers_dir}/jevs_analyses_rtma_precip_stats.sh
qsub -v vhr=$vhr ${drivers_dir}/jevs_analyses_urma_grid2obs_stats.sh
qsub -v vhr=$vhr ${drivers_dir}/jevs_analyses_urma_precip_stats.sh
qsub -v vhr=$vhr ${drivers_dir}/jevs_analyses_rtma_ru_grid2obs_stats.sh
qsub -v vhr=$vhr ${drivers_dir}/jevs_analyses_ccpa_precip_stats.sh
