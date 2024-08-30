#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS
STEP=plots
COMPONENT=global_det

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
run_job=$1
plots_job=$2
if [ $run_job == wave ]; then
    qsub ${drivers_dir}/jevs_global_det_${run_job}_${plots_job}_plots_last31days.sh
    qsub ${drivers_dir}/jevs_global_det_${run_job}_${plots_job}_plots_last90days.sh
elif [ $run_job == atmos ]; then
    if [ $plots_job == headline ]; then
        qsub ${drivers_dir}/jevs_global_det_${run_job}_${plots_job}_plots.sh
    else
        if [ $plots_job == grid2grid ]; then
            subplots="means precip pres_levs sea_ice snow sst"
        elif [ $plots_job == grid2obs ]; then
            subplots="pres_levs ptype sfc"
        fi
        for subplot in $subplots; do
            qsub ${drivers_dir}/jevs_global_det_${run_job}_${plots_job}_${subplot}_plots_last31days.sh
            qsub ${drivers_dir}/jevs_global_det_${run_job}_${plots_job}_${subplot}_plots_last90days.sh
        done
    fi
fi
