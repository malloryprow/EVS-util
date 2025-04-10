#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS
STEP=stats
COMPONENT=mesoscale

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
subcomponent_job=$1
stats_job=$2
if [ $subcomponent_job == det ]; then
    models="nam rap"
    for model in ${models}; do
        qsub -v vhr=$vhr ${drivers_dir}/jevs_mesoscale_${model}_${stats_job}_stats.sh
    done
elif [ $subcomponent_job == ens ]; then
    if [ ${stats_job} == all ]; then
        for all_job in grid2obs precip; do
            qsub ${drivers_dir}/jevs_mesoscale_sref_${all_job}_stats.sh
        done
    else
        qsub ${drivers_dir}/jevs_mesoscale_sref_${stats_job}_stats.sh
    fi
fi
