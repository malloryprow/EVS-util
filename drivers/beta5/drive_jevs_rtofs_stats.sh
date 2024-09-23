#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS_beta5
STEP=stats
COMPONENT=rtofs

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output_beta5
cd /lfs/h2/emc/ptmp/${USER}/output_beta5

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
g2g_obs="aviso ghrsst osisaf smap smos"
for obs in ${g2g_obs}; do
    qsub ${drivers_dir}/jevs_rtofs_${obs}_grid2grid_stats.sh
done
g2o_obs="argo ndbc"
for obs in ${g2o_obs}; do
    qsub ${drivers_dir}/jevs_rtofs_${obs}_grid2obs_stats.sh
done
