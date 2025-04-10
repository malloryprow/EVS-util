#!/bin/bash
#################################################
# Author: Perry Shafran
# Purpose: Cleans up the ptmp tar directory once
#          files are transferred to emcrzdm
#          Clears the restart directories and tarballs
#################################################

set -x

# Module Loads
module load prod_util

# Get EVS COMPONENT
COMPONENT=${1:-${COMPONENT:-"component"}}
RUN=${2:-${RUN:-"run"}}
VDATE=${3:-${VDATE:-"vdate"}}

# EVS Output Info
user_para=/lfs/h2/emc/ptmp/${USER}/evs/v2.0/plots

# Clean up restart directories
COMPONENT_RUN_VDATE=${COMPONENT}/${RUN}.${VDATE}
echo "Clearing out restart directories for date selected"
for dir in CEILING DPT GUST TCDC TMP VIS WIND grid* RH precip restart snowfall UGRD* VGRD plots
do
   rm -f -r ${user_para}/${COMPONENT_RUN_VDATE}/${dir}
done

# Clean up tarball directory
echo "Clearing out tarball directory for one day before date selected"
rm_VDATE=$($NDATE -24 ${VDATE}00 |cut -c1-8)
COMPONENT_RUN_RM_VDATE=${COMPONENT}/${RUN}.${rm_VDATE}
rm -f -r ${user_para}/${COMPONENT_RUN_RM_VDATE}

