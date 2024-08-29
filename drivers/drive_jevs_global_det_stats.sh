#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS
STEP=stats
COMPONENT=global_det

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
run_job=$1
stats_job=$2
if [ $run_job == wave ]; then
    if [ $stats_job == grid2obs ]; then
        models="gfs"
    fi
elif [ $run_job == atmos ]; then
    if [ $stats_job == grid2grid ]; then
        models="cfs cmc cmc_regional dwd ecmwf fnmoc gfs imd jma metfra ukmet"
    elif [ $stats_job == grid2obs ]; then
        models="cfs cmc ecmwf fnmoc gfs imd jma ukmet"
    else
        models="gfs"
    fi
fi
for model in $models; do
    qsub ${drivers_dir}/jevs_global_det_${model}_${run_job}_${stats_job}_stats.sh
done
