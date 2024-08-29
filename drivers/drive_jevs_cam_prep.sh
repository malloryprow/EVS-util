#!/bin/bash
# Author: L.C. Dawson, Mallory Row
###########################################################
# Called on a cron to run EVS jobs                        #
###########################################################

set -x

HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS
STEP=prep
COMPONENT=cam

now=$(date -u +%Y%m%d%H)
vhr=$(echo $now | cut -c 9-10)

mkdir -p /lfs/h2/emc/ptmp/${USER}/output
cd /lfs/h2/emc/ptmp/${USER}/output

module reset

drivers_dir=${HOMEevs}/dev/drivers/scripts/${STEP}/${COMPONENT}
prep_job=$1
if [ $prep_job == radar ]; then
    qsub -v vhr=$vhr ${drivers_dir}/jevs_cam_${prep_job}_prep.sh
elif [ $prep_job == precip ]; then
    models="hireswarw hireswarwmem2 hireswfv3 hrrr namnest"
    for model in ${models}; do
        qsub -v vhr=$vhr ${drivers_dir}/jevs_cam_${model}_${prep_job}_prep.sh
    done
elif [ $prep_job == severe ]; then
    qsub -v vhr=$vhr ${drivers_dir}/jevs_cam_${prep_job}_prep.sh
elif [ $prep_job == severe_hrrr ]; then
    qsub -v vhr=$vhr ${drivers_dir}/jevs_cam_hrrr_severe_prep.sh
elif [ $prep_job == severe_namnest ]; then
    qsub -v vhr=$vhr ${drivers_dir}/jevs_cam_namnest_severe_prep.sh
elif [ $prep_job == severe_hireswfv3 ]; then
    qsub -v vhr=$vhr ${drivers_dir}/jevs_cam_hireswfv3_severe_prep.sh
elif [ $prep_job == severe_hireswarw ]; then
    qsub -v vhr=$vhr ${drivers_dir}/jevs_cam_hireswarw_severe_prep.sh
elif [ $prep_job == severe_hireswarwmem2 ]; then
    qsub -v vhr=$vhr ${drivers_dir}/jevs_cam_hireswarwmem2_severe_prep.sh
elif [ $prep_job == severe_href ]; then
    qsub -v vhr=$vhr ${drivers_dir}/jevs_cam_href_severe_prep.sh
fi
