#!/bin/bash

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
