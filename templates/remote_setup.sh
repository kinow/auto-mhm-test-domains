#!/bin/bash

set -eux -o pipefail

cd %PLATFORMS.REMOTE.SCRATCH_DIR%

# git clone only the directories for mHM test data
# https://stackoverflow.com/questions/600079/how-do-i-clone-a-subdirectory-only-of-a-git-repository
# https://askubuntu.com/questions/460885/how-to-clone-only-some-directories-from-a-git-repository

if [[ ! -d "data" ]]; then
  echo "Creating the data directories by cloning it from mHM Git repository"
  mkdir data
  cd data
  git init
  git remote add -f upstream https://github.com/mhm-ufz/mHM.git

  git config core.sparseCheckout true

  echo "test_domain/" >> .git/info/sparse-checkout
  echo "test_domain_2/" >> .git/info/sparse-checkout

  git pull upstream v5.12.0
fi

cd %PLATFORMS.REMOTE.SCRATCH_DIR%

# Create Singularity sandboxes
echo "Creating singularity sandboxes"
for START_DATE in %EXPERIMENT.DATELIST%
do
  EVAL_PERIOD_START="${START_DATE:0:4}"
  EVAL_PERIOD_DURATION_YEARS="%MHM.EVAL_PERIOD_DURATION_YEARS%"
  EVAL_PERIOD_END=$((EVAL_PERIOD_START+EVAL_PERIOD_DURATION_YEARS))
  echo "Copying data directory for the start date ${EVAL_PERIOD_START}, to data_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}"
  MHM_DATA_DIR="data_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}"
  cp -r data "${MHM_DATA_DIR}"

  MHM_SINGULARITY_SANDBOX_DIR="mhm_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}"
  echo "Creating singularity sandbox ${MHM_SINGULARITY_SANDBOX_DIR}"
  if [[ ! -d "${MHM_SINGULARITY_SANDBOX_DIR}" ]]; then
    echo "Creating new singularity sandbox ${MHM_SINGULARITY_SANDBOX_DIR}"
    singularity build --sandbox "${MHM_SINGULARITY_SANDBOX_DIR}" mhm.sif
  fi
done

echo "REMOTE_SETUP complete!"
