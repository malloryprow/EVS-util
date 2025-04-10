#!/bin/bash
#
#PBS -N cleanup_ptmp
#PBS -o /lfs/h2/emc/ptmp/emc.vpppg/cleanup_ptmp.out
#PBS -e /lfs/h2/emc/ptmp/emc.vpppg/cleanup_ptmp.out
#PBS -q "dev"
#PBS -l select=1:ncpus=1:mem=40000MB
#PBS -A VERF-DEV
#PBS -l walltime=06:00:00
#PBS -l debug=true
#PBS -V

set -x

module load prod_util

today=$(cut -c7-14 /lfs/h1/ops/prod/com/date/t00z)
VDATE_RM=${VDATE_RM:-$(finddate.sh $today d-6)}

rm -f -r /lfs/h2/emc/ptmp/emc.vpppg/evs/v2.0/plots/analyses/*${VDATE_RM}*
rm -f -r /lfs/h2/emc/ptmp/emc.vpppg/evs/v2.0/plots/aqm/*${VDATE_RM}*
rm -f -r /lfs/h2/emc/ptmp/emc.vpppg/evs/v2.0/plots/cam/*${VDATE_RM}*
rm -f -r /lfs/h2/emc/ptmp/emc.vpppg/evs/v2.0/plots/global_det/*${VDATE_RM}*
rm -f -r /lfs/h2/emc/ptmp/emc.vpppg/evs/v2.0/plots/global_ens/*${VDATE_RM}*
rm -f -r /lfs/h2/emc/ptmp/emc.vpppg/evs/v2.0/plots/glwu/*${VDATE_RM}*
rm -f -r /lfs/h2/emc/ptmp/emc.vpppg/evs/v2.0/plots/mesoscale/*${VDATE_RM}*
rm -f -r /lfs/h2/emc/ptmp/emc.vpppg/evs/v2.0/plots/narre/*${VDATE_RM}*
rm -f -r /lfs/h2/emc/ptmp/emc.vpppg/evs/v2.0/plots/nfcens/*${VDATE_RM}*
rm -f -r /lfs/h2/emc/ptmp/emc.vpppg/evs/v2.0/plots/nwps/*${VDATE_RM}*
rm -f -r /lfs/h2/emc/ptmp/emc.vpppg/evs/v2.0/plots/rtofs/*${VDATE_RM}*
rm -f -r /lfs/h2/emc/ptmp/emc.vpppg/evs/v2.0/plots/subseasonal/*${VDATE_RM}*
rm -f -r /lfs/h2/emc/ptmp/emc.vpppg/evs/v2.0/plots/wafs/*${VDATE_RM}*

exit


