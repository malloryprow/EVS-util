#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS
STEP=plots
COMPONENT=global_ens

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
run_job=$1
plots_job=$2
if [ $run_job == atmos ]; then
    qsub ${drivers_dir}/jevs_global_ens_atmos_${plots_job}_plots.sh
elif [ $run_job == wave ]; then
    qsub ${drivers_dir}/jevs_global_ens_wave_${plots_job}_plots.sh
elif [ $run_job == chem ]; then
    qsub ${drivers_dir}/jevs_global_ens_chem_gefs_${plots_job}.sh
fi
