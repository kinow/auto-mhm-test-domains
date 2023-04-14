#!/bin/bash

set -eux -o pipefail

echo "Plotting PNG files for each timestep of the PET variable in the mHM_Fluxes_States.nc output file"

function plot() {
  OUTPUT_FOLDER=$1
  echo "Using output from output folder: ${OUTPUT_FOLDER}"
  singularity exec mhm.sif /opt/conda/bin/python plot.py \
      --variable "PET" \
      --input "${OUTPUT_FOLDER}/mHM_Fluxes_States.nc" \
      --output "${OUTPUT_FOLDER}"
  convert \
      -delay 30 \
      -loop 0 \
      "${OUTPUT_FOLDER}/*.png" \
      "${OUTPUT_FOLDER}/plot_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}.gif"
  OUTPUT_FOLDER_PARENT=$(basename "${OUTPUT_FOLDER}")
  OUTPUT_FOLDER_BASENAME=$(dirname "${OUTPUT_FOLDER}")
  tar \
      -zcvf "mhm_output_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}.tar.gz" \
      -C "${OUTPUT_FOLDER_PARENT}" \
      "${OUTPUT_FOLDER_BASENAME}"
}

plot "data/test_domain/output_b1/"
plot "data/test_domain_2/output/"

echo "GRAPH complete!"
