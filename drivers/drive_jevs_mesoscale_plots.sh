#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS
STEP=plots
COMPONENT=mesoscale

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
subcomponent_job=$1
plots_job=$2
if [ $subcomponent_job == det ]; then
    qsub -v vhr=$vhr ${drivers_dir}/jevs_mesoscale_${plots_job}_plots.sh
elif [ $subcomponent_job == ens ]; then
    if [ $plots_job == all ]; then
        verif_cases="grid2obs precip cnv cape cloud td2m"
        for verif_case in ${verif_cases}; do
            qsub ${drivers_dir}/jevs_mesoscale_sref_${verif_case}_last90days_plots.sh
        done
        qsub ${drivers_dir}/jevs_mesoscale_sref_precip_spatial_plots.sh
    fi
fi
