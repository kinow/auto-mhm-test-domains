#!/bin/bash

set -eux -o pipefail

cd %PROJDIR%

echo "Copying remote data"

scp %PLATFORMS.REMOTE.USER%@%PLATFORMS.REMOTE.HOST%:%PLATFORMS.REMOTE.SCRATCH_DIR%/mhm_output*.tar.gz \
    %PLATFORMS.REMOTE.USER%@%PLATFORMS.REMOTE.HOST%:%PLATFORMS.REMOTE.SCRATCH_DIR%/plot*.gif \
    .

echo "SYNC_FROM_REMOTE complete!"
