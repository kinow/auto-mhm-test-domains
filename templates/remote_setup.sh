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

#######################################
# Create the remote workflow run directory.
# Globals:
#   None
# Arguments:
#   Remote workflow run directory.
# Outputs:
#   0 if the directory exists or can be correctly created, >0 otherwise.
#######################################
remote_setup() {
  remote_workflow_run_dir=$1
  if [ ! -d "${remote_workflow_run_dir}" ]; then
    mkdir -pv "${remote_workflow_run_dir}"
  fi
}

remote_setup "${REMOTE_WORKFLOW_RUN_DIRECTORY}"
