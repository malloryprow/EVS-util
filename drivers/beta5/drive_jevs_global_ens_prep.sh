#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS_beta5
STEP=prep
COMPONENT=global_ens

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output_beta5
cd /lfs/h2/emc/ptmp/${USER}/output_beta5

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
run_job=$1
if [ $run_job == atmos ]; then
    qsub ${drivers_dir}/jevs_global_ens_atmos_prep.sh
    qsub ${drivers_dir}/jevs_global_ens_naefs_atmos_prep.sh
elif [ $run_job == atmos_headline ]; then
    qsub ${drivers_dir}/jevs_global_ens_headline_prep.sh
elif [ $run_job == chem ]; then
    qsub ${drivers_dir}/jevs_global_ens_chem_grid2obs_prep.sh
elif [ $run_job == wave ]; then
    qsub ${drivers_dir}/jevs_global_ens_wave_grid2obs_prep.sh
fi
