# Autosubmit mHM workflow with mHM test domains data

This repository contains the configuration for an Autosubmit
workflow that runs mHM with its test domain data. A Docker
container is used to run mHM.

## The workflow

An Autosubmit workflow created with
`autosubmit expid -H local -d "mHM" -min -git https://github.com/kinow/auto-mhm-test-domains.git`
when triggered will clone this repository, and prepare the Docker
& Singularity containers, transfer over to the remote platform
(can be `localhost` for testing) and execute the mHM model for
each start date (as the mHM simulation period date). Finally, the
workflow plots the data before cleaning the simulation logs and
files.

The plots are copied back to the local workflow folder, and
everything can be used to package an RO-Crate.

## Running

TODO: document commands used to run and monitor the workflow. It
      must include a step-by-step to re-run the workflow and get
      the same result (i.e. same RO-Crate described at the end.)

## License

TODO: Add OSI license file and link it here.

## RO-Crate

TODO: document the `rocrate.json` used to help populating the
`ro-crate-metadata.json` (partials, with license, author, inputs,
and outputs)…
