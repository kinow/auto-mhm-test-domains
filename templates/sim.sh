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
CONTAINER_LOCATION="%MHM.SINGULARITY_CONTAINER%"

#######################################
# Run mHM.
# Globals:
#   None
# Arguments:
#   Remote data directory.
#   Container location.
# Outputs:
#   0 if the directory exists or can be correctly created, >0 otherwise.
#######################################
sim() {
  local remote_data_directory=$1
  local container_location=$2

  pushd "${remote_data_directory}"
  echo "Running mHM test domain simulation with test data located at ${remote_data_directory}"
  singularity exec "${container_location}" \
    /opt/conda/bin/mhm \
    "${remote_data_directory}"
  popd
}

sim "${MHM_DATA_DIRECTORY}" "${CONTAINER_LOCATION}"
