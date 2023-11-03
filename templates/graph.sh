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

REMOTE_WORKFLOW_RUN_DIRECTORY="%PLATFORMS.REMOTE.SCRATCH_DIR%/%PLATFORMS.REMOTE.PROJECT%/%PLATFORMS.REMOTE.USER%/%DEFAULT.EXPID%"
MHM_DATA_DIRECTORY="${REMOTE_WORKFLOW_RUN_DIRECTORY}/data"
MHM_DATA_DIRECTORY_OUTPUT="${MHM_DATA_DIRECTORY}/output_b1/"
PLOT_SCRIPT_LOCATION="${REMOTE_WORKFLOW_RUN_DIRECTORY}/plot.py"
CONTAINER_LOCATION="%MHM.SINGULARITY_CONTAINER%"

echo "Plotting PNG files for each timestep of the PET variable in the mHM_Fluxes_States.nc output file"

#######################################
# Run mHM.
# Globals:
#   None
# Arguments:
#   Plot script location.
#   Remote data directory.
#   Container location.
# Outputs:
#   0 if the plot is created and the outputs saved, >0 otherwise.
#######################################
function plot() {
  local plot_script_location=$1
  local output_folder=$2
  local container_location=$3
  local output_folder_parent=$(dirname "${output_folder}")
  local output_folder_basename=$(basename "${output_folder}")
  local tar_file="${output_folder_parent}/mhm_output.tar.gz"

  singularity exec \
    --bind "${plot_script_location}":"${plot_script_location}" \
    --bind "${output_folder}":"${output_folder}" \
    "${container_location}" /opt/conda/bin/python "${plot_script_location}" \
    --variable "PET" \
    --input "${output_folder}/mHM_Fluxes_States.nc" \
    --output "${output_folder}"

  convert \
    -delay 30 \
    -loop 0 \
    "${output_folder}/*.png" \
    "${output_folder_parent}/plot.gif"

  tar \
    -zcvf "${tar_file}" \
    -C "${output_folder_parent}" \
    "${output_folder_basename}"

}

plot "${PLOT_SCRIPT_LOCATION}" "${MHM_DATA_DIRECTORY_OUTPUT}" "${CONTAINER_LOCATION}"
