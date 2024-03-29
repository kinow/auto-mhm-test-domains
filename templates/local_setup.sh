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
MHM_DATA_DIRECTORY="${LOCAL_WORKFLOW_RUN_DIRECTORY}/data"
CONTAINER_LOCATION="%MHM.SINGULARITY_CONTAINER%"
MHM_BRANCH_NAME="%MHM.BRANCH_NAME%"
MHM_DOMAIN_NAME="%MHM.DOMAIN%"
PROJECT_DIRECTORY="%PROJDIR%"

#######################################
# Verify that the container exists and print information about it.
# Globals:
#   None
# Arguments:
#   Container location.
# Outputs:
#   0 if the container exists and is valid, >0 otherwise.
#######################################
test_container() {
  local container_location=$1
  singularity inspect --all "${container_location}"
}

#######################################
# Verify that the container exists and print information about it.
# Also copies the `plot.py` file into the workflow run directory.
# Globals:
#   None
# Arguments:
#   Workflow run directory.
#   Project directory.
# Outputs:
#   0 if the directories can be created correctly, >0 otherwise.
#######################################
prepare_workflow_run_directory() {
  local workflow_run_directory=$1
  local project_directory=$2
  if [ ! -d "${workflow_run_directory}" ]; then
    mkdir -pv "${workflow_run_directory}"
  fi
  cp "${project_directory}/plot.py" "${workflow_run_directory}"
}

#######################################
# Verify that the container exists and print information about it.
# Globals:
#   None
# Arguments:
#   Data directory.
#   Container location.
#   mHM branch name.
#   mHM domain.
# Outputs:
#   0 if the data has been downloaded correctly, >0 otherwise.
#######################################
download_test_data() {
  local data_directory=$1
  local container_location=$2
  local branch_name=$3
  local domain=$4
  # We started cloning the data directory from Git, but then we realized we could
  # use mHM utility that downloads the test data. The only downside to this is that
  # we need to have the same container deployed locally and remotely (assuming that
  # we want an offline remote execution).
  #
  # Git clone only the directories for mHM test data:
  # https://stackoverflow.com/questions/600079/how-do-i-clone-a-subdirectory-only-of-a-git-repository
  # https://askubuntu.com/questions/460885/how-to-clone-only-some-directories-from-a-git-repository
  if [ ! -d "${data_directory}" ]; then
    singularity run "${container_location}" mhm-download -b "${branch_name}" -d "${domain}" -p "${data_directory}"
  fi
}

test_container "${CONTAINER_LOCATION}"

prepare_workflow_run_directory "${LOCAL_WORKFLOW_RUN_DIRECTORY}" "${PROJECT_DIRECTORY}"

download_test_data "${MHM_DATA_DIRECTORY}" "${CONTAINER_LOCATION}" "${MHM_BRANCH_NAME}" "${MHM_DOMAIN_NAME}"
