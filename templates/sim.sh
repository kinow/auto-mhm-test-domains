#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

set -eux -o pipefail

cd "%PLATFORMS.REMOTE.SCRATCH_DIR%/%PLATFORMS.REMOTE.PROJECT%/%PLATFORMS.REMOTE.USER%/%DEFAULT.EXPID%"

# SDATE will be formatted as 19930101
START_DATE="%SDATE%"

echo "START DATE is ${START_DATE}"

# This will result in 1993 for the example above
EVAL_PERIOD_START="${START_DATE:0:4}"
EVAL_PERIOD_DURATION_YEARS="%MHM.EVAL_PERIOD_DURATION_YEARS%"
EVAL_PERIOD_END=$((EVAL_PERIOD_START+EVAL_PERIOD_DURATION_YEARS))

MHM_SINGULARITY_SANDBOX_DIR="mhm_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}"
MHM_DATA_DIR="data_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}"

echo "Running mHM simulation with eval period start [${EVAL_PERIOD_START}] and end [${EVAL_PERIOD_END}]"

cp mhm.nml "${MHM_DATA_DIR}/mhm_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}.nml"
sed -i -E "s/eval_Per\(([0-9])\)%yStart = ([0-9]+)/eval_Per\(\1\)%yStart = $EVAL_PERIOD_START/" "${MHM_DATA_DIR}/mhm_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}.nml"
sed -i -E "s/eval_Per\(([0-9])\)%yEnd = ([0-9]+)/eval_Per\(\1\)%yEnd = EVAL_PERIOD_END/" "${MHM_DATA_DIR}/mhm_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}.nml"
sed -i "s|test_domain/|${MHM_DATA_DIR}/test_domain/|" "${MHM_DATA_DIR}/mhm_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}.nml"
sed -i "s|test_domain_2/|${MHM_DATA_DIR}/test_domain_2/|" "${MHM_DATA_DIR}/mhm_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}.nml"

singularity exec "${MHM_SINGULARITY_SANDBOX_DIR}" /opt/conda/bin/mhm \
    --nml "mhm_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}.nml" "${MHM_DATA_DIR}"

echo "SIM complete!"
