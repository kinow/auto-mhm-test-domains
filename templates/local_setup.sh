#!/bin/bash

set -eux -o pipefail

echo "Creating the Docker container for mHM v%MHM.VERSION%"

cd %PROJDIR%

docker build \
  --no-cache=true \
  --tag "auto-mhm-test-domains/mhm:v%MHM.VERSION%" .

echo "Creating the Singularity container for mHM v%MHM.VERSION%"

sudo singularity build mhm.sif "docker-daemon://auto-mhm-test-domains/mhm:v%MHM.VERSION%"
