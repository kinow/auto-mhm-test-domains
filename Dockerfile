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

FROM mambaorg/micromamba:bullseye-slim

RUN micromamba install --yes --name base --channel conda-forge \
    fypp==3.1 \
    cmake==3.26.3 \
    ninja==1.11.1 \
    netcdf-fortran==4.6.0 \
    fortran-compiler==1.5.2 \
    c-compiler==1.5.2 \
    cxx-compiler==1.5.2 \
    libgomp==12.2.0 \
    pip==23.1.2 \
    setuptools==63.4.3 \
    setuptools-scm==7.1.0 \
    scikit-build==0.16.7 \
    f90nml==1.4.3 \
    git==2.40.1 \
    python==3.10 \
    numpy==1.21.6 \
    imagemagick==7.1.1_6 \
    xarray==2023.3.0 \
    netcdf4==1.6.3 \
    matplotlib==3.7.1 && \
    micromamba clean --all --yes

RUN MHM_BUILD_PARALLEL=1 /opt/conda/bin/pip install git+https://git.ufz.de/mhm/mhm.git@98c8466e07cc1b5a9cfd98a7a6f699526a11d260 --no-deps --no-build-isolation -vv

WORKDIR /
CMD ["mhm"]
