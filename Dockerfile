FROM mambaorg/micromamba:bullseye-slim

RUN micromamba install --yes --name base --channel conda-forge \
    python==3.10 \
    mHM==5.12.0 && \
    micromamba clean --all --yes

WORKDIR /
CMD ["mhm"]
