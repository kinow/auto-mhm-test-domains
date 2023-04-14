FROM mambaorg/micromamba:bullseye-slim

RUN micromamba install --yes --name base --channel conda-forge \
    python==3.10 \
    imagemagick==7.1.1_6 \
    mHM==5.12.0 \
    xarray==2023.3.0 \
    netcdf4==1.6.3 \
    matplotlib==3.7.1 && \
    micromamba clean --all --yes

WORKDIR /
CMD ["mhm"]
