#!/bin/bash

set -eux -o pipefail

echo "Creating the Docker container for mHM v%MHM.VERSION%"

cd %PROJDIR%

if [[ ! -f mhm.sif ]]; then

  docker build \
    --no-cache=true \
    --tag "auto-mhm-test-domains/mhm:v%MHM.VERSION%" .

  echo "Creating the Singularity container for mHM v%MHM.VERSION%"

  sudo singularity build --force mhm.sif "docker-daemon://auto-mhm-test-domains/mhm:v%MHM.VERSION%"

fi

singularity inspect --all mhm.sif

echo "LOCAL_SETUP complete!"