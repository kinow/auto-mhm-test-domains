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

LOCAL_WORKFLOW_RUN_DIRECTORY="%PROJDIR%/run"
REMOTE_WORKFLOW_RUN_DIRECTORY="%PLATFORMS.REMOTE.SCRATCH_DIR%/%PLATFORMS.REMOTE.PROJECT%/%PLATFORMS.REMOTE.USER%/%DEFAULT.EXPID%"
SCP_USER="%PLATFORMS.REMOTE.USER%@%PLATFORMS.REMOTE.HOST%"

#######################################
# Copy files from the project directory to the workflow run directory.
# Globals:
#   None
# Arguments:
#   Local workflow run directory.
#   Remote workflow run directory.
#   SCP user string (user@host).
# Outputs:
#   0 if the files are successfully copied via scp, >0 otherwise.
#######################################
copy_files() {
  local local_workflow_run_directory=$1
  local remote_workflow_run_directory=$2
  local scp_user=$3
  local target_location="${scp_user}:${remote_workflow_run_directory}"
  echo "Copying the mHM data and scripts via scp to: ${target_location}"
  scp -v -r \
    "${local_workflow_run_directory}/"* \
    "${target_location}"
}

copy_files "${LOCAL_WORKFLOW_RUN_DIRECTORY}" "${REMOTE_WORKFLOW_RUN_DIRECTORY}" "${SCP_USER}"
