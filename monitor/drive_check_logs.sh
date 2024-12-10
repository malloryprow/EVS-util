#PBS -N drive_check_logs
#PBS -j oe
#PBS -S /bin/bash
#PBS -q dev
#PBS -A VERF-DEV
#PBS -l walltime=01:00:00
#PBS -l place=shared,select=1:ncpus=1:mem=15GB
#PBS -l debug=true

set -x 

cd $PBS_O_WORKDIR

python /lfs/h2/emc/vpppg/noscrub/${USER}/EVS-util/monitor/check_logs.py 
