#!/bin/bash

set -eux -o pipefail

cd %PLATFORMS.REMOTE.SCRATCH_DIR%

# git clone only the directories for mHM test data
# https://stackoverflow.com/questions/600079/how-do-i-clone-a-subdirectory-only-of-a-git-repository
# https://askubuntu.com/questions/460885/how-to-clone-only-some-directories-from-a-git-repository

mkdir data
cd data
git init
git remote add -f upstream https://github.com/mhm-ufz/mHM.git

git config core.sparseCheckout true

echo "test_domain/" >> .git/info/sparse-checkout
echo "test_domain_2/" >> .git/info/sparse-checkout

git pull upstream v5.12.0

echo "REMOTE_SETUP complete!"
