#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS
STEP=stats
COMPONENT=global_ens

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
run_job=$1
if [ $run_job == atmos ]; then
    model=$2
    verif_case=$3
    if [ $model == all ]; then
        if [ $verif_case = snowfall ]; then
            models="gefs cmce ecme"
        elif [ $verif_case = sst -o $verif_case = sea_ice -o $verif_case = cnv ]; then
            models="gefs"
        elif [ $verif_case = grid2grid -o $verif_case = grid2obs -o $verif_case = precip ]; then
            models="gefs cmce ecme naefs"
        fi
    else
        models=${model}
    fi
    for run_model in ${models}; do
        qsub ${drivers_dir}/jevs_global_ens_${run_model}_atmos_${verif_case}_stats.sh
    done
elif [ $run_job == atmos_headline ]; then
    model=$2
    if [ $model == all ]; then
        models="gfs gefs naefs"
    else
        models=${model}
    fi
    for run_model in ${models}; do
        qsub ${drivers_dir}/jevs_global_ens_${run_model}_headline_grid2grid_stats.sh
    done
elif [ $run_job == wave ]; then
    qsub ${drivers_dir}/jevs_global_ens_wave_grid2obs_stats.sh
elif [ $run_job == chem_grid2obs_airnow ]; then
    run_vhr=$(($vhr-1))
    if [ $run_vhr -lt 10 ]; then
        run_vhr=0${run_vhr}
    fi
    qsub -v vhr=$run_vhr ${drivers_dir}/jevs_global_ens_gefs_${run_job}_stats.sh
elif [ $run_job == chem_grid2obs_aeronet ]; then
    run_vhr=$((${vhr#0}-2))
    if [ $run_vhr -lt 10 ]; then
        run_vhr=0${run_vhr}
    fi
    qsub -v vhr=$run_vhr ${drivers_dir}/jevs_global_ens_gefs_${run_job}_stats.sh
fi
