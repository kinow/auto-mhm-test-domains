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
SCP_USER="%PLATFORMS.REMOTE.USER%@%PLATFORMS.REMOTE.HOST%"
PROJECT_DIRECTORY="%PROJDIR%"

#######################################
# Copy files from the workflow directory to the project directory.
# Globals:
#   None
# Arguments:
#   Remote mhm data directory.
#   SCP user string (user@host).
#   Autosubmit project directory location.
# Outputs:
#   0 if the files are successfully copied via scp, >0 otherwise.
#######################################
copy_files() {
  local remote_mhm_data_directory=$1
  local scp_user=$2
  local project_directory=$3
  local target_location="${scp_user}:${remote_mhm_data_directory}"
  scp \
    "${target_location}/mhm_output.tar.gz" \
    "${target_location}/plot.gif" \
    "${project_directory}"
}

copy_files $MHM_DATA_DIRECTORY $SCP_USER $PROJECT_DIRECTORY
