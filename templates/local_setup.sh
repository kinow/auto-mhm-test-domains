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

echo "Creating the Docker container for mHM v%MHM.VERSION%"

cd %PROJDIR%

if [[ ! -f mhm.sif ]]; then

  docker build \
    --no-cache=true \
    --tag "auto-mhm-test-domains/mhm:v%MHM.VERSION%" .

  echo "Creating the Singularity container for mHM v%MHM.VERSION%"

  singularity build --force mhm.sif "docker-daemon://auto-mhm-test-domains/mhm:v%MHM.VERSION%"

fi

singularity inspect --all mhm.sif

echo "LOCAL_SETUP complete!"