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

echo "Cleaning remote files"

if [[ -d "%PLATFORMS.REMOTE.SCRATCH_DIR%" && "%PLATFORMS.REMOTE.SCRATCH_DIR%" != "/" ]]; then

  cd %PLATFORMS.REMOTE.SCRATCH_DIR%

  # NOTE: must not delete the remote folder with the user name, as that hold
  #       the
  find . -type d -maxdepth 1 -not -path "./%PLATFORMS.REMOTE.USER%" -exec rm -rvf {} \;
  find . -type f -maxdepth 1 -exec rm -v {} \;

fi

echo "CLEAN complete!"
