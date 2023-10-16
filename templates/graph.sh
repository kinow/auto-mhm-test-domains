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

echo "Plotting PNG files for each timestep of the PET variable in the mHM_Fluxes_States.nc output file"

function plot() {
  local OUTPUT_FOLDER=$1
  echo "Output folder is: ${OUTPUT_FOLDER}"
  singularity exec "${MHM_SINGULARITY_SANDBOX_DIR}" /opt/conda/bin/python plot.py \
      --variable "PET" \
      --input "${OUTPUT_FOLDER}/mHM_Fluxes_States.nc" \
      --output "${OUTPUT_FOLDER}"
  convert \
      -delay 30 \
      -loop 0 \
      "${OUTPUT_FOLDER}/*.png" \
      "${OUTPUT_FOLDER}/plot_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}.gif"
  local OUTPUT_FOLDER_PARENT=$(dirname "${OUTPUT_FOLDER}")
  echo "Output folder parent is: ${OUTPUT_FOLDER_PARENT}"
  local OUTPUT_FOLDER_BASENAME=$(basename "${OUTPUT_FOLDER}")
  echo "Output folder basename is: ${OUTPUT_FOLDER_BASENAME}"
  local TAR_FILE="mhm_output_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}.tar.gz"
  tar \
    -zcvf "mhm_output_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}.tar.gz" \
    -C "${OUTPUT_FOLDER_PARENT}" \
    "${OUTPUT_FOLDER_BASENAME}"
  echo "Copying GIF to directory: ${PWD}"
  cp "${OUTPUT_FOLDER}/plot_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}.gif" .
}

plot "${MHM_DATA_DIR}/output_b1/"

echo "GRAPH complete!"
