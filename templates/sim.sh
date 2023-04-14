#!/bin/bash

set -eux -o pipefail

cd %PLATFORMS.REMOTE.SCRATCH_DIR%

# SDATE will be formatted as 19930101
START_DATE="%SDATE%"

echo "START DATE is ${START_DATE}"

# This will result in 1993 for the example above
EVAL_PERIOD_START="${START_DATE:0:4}"
EVAL_PERIOD_DURATION_YEARS="%MHM.EVAL_PERIOD_DURATION_YEARS%"
EVAL_PERIOD_END=$((EVAL_PERIOD_START+EVAL_PERIOD_DURATION_YEARS))

echo "Running mHM simulation with eval period start [${EVAL_PERIOD_START}] and end [${EVAL_PERIOD_END}]"

cp mhm.nml "mhm_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}.nml"
sed -i -E "s/eval_Per\(([0-9])\)%yStart = ([0-9]+)/eval_Per\(\1\)%yStart = $EVAL_PERIOD_START/" "mhm_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}.nml"
sed -i -E "s/eval_Per\(([0-9])\)%yEnd = ([0-9]+)/eval_Per\(\1\)%yEnd = EVAL_PERIOD_END/" "mhm_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}.nml"
sed -i "s|test_domain/|data/test_domain/|" "mhm_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}.nml"
sed -i "s|test_domain_2/|data/test_domain_2/|" "mhm_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}.nml"

apptainer exec mhm.sif /opt/conda/bin/mhm --nml "mhm_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}.nml"

echo "SIM complete!"
