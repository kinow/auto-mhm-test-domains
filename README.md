<!--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->

# Autosubmit mHM workflow with mHM test domains data

This repository contains the configuration for an [Autosubmit][autosubmit]
workflow that runs [mHM][mhm], the mesoscale hydrological model, using
the mHM test domain data. A Docker container is used to run mHM.

The two images below were created using the workflow in this
repository, and running the [`plot.py`][plotpy] script (it uses
Xarray and Matplotlib to parse the NetCDF test output).

<div>
  <img src="./docs/plot_1991_1993.gif" style="max-width: 400px;" />
  <img src="./docs/plot_1993_1995.gif" style="max-width: 400px;" />
</div>

## Prerequisites

<!--
NOTE: With CWL you can list the software requirements for a computational
      workflow. Unfortunately we do not have the same for Autosubmit. But
      maybe we could find a way to give a specification of requirements?
      CWL can also declare that a workflow or tool needs Internet, and
      even Docker. So everything in this section can be part of the CWL
      Workflow definition. Would be nice to have something we could use
      in Autosubmit (like a standard way of defining it?).
-->

In order to run this workflow you will need the following:

1. Internet connection
2. Linux
3. Autosubmit 4.x (e.g. `pip install autosubmit`)
4. Docker & Singularity 3.11.x for containers

For a list of software used, besides `mHM`, see the [`Dockerfile`][dockerfile].

## Workflow

An Autosubmit workflow created with
`autosubmit expid -H local -d "mHM" -min -git https://github.com/kinow/auto-mhm-test-domains.git`
when triggered will clone this repository, and prepare the Docker
& Singularity containers, transfer over to the remote platform
(can be `localhost` for testing) and execute the mHM model for
each start date (as the mHM simulation period date). Finally, the
workflow plots the data before cleaning the simulation logs and
files.

<img src="./docs/mhm-workflow-graph.png" style="max-width: 400px; max-height: 400px;" />

The plots are copied back to the local workflow folder, and
everything can be used to package an RO-Crate.

## Running

You will need an Autosubmit experiment first, so that you
can import the configuration files from this repository.
Run the following command to create a new Autosubmit experiment.

```bash
autosubmit expid \
    --HPC "local" \
    --description "Autosubmit mHM test domains" \
    --minimal_configuration \
    --git_as_conf conf \
    --git_repo https://github.com/kinow/auto-mhm-test-domains.git \
    --git_branch master
```

That will create a new experiment, using local SSH connections
(it is using the default “local” platform), and on the first
execution of `create`, it will clone the Git repository specified
and load the configuration from its `git_as_conf` subdirectory.

> NOTE: the output of `autosubmit expid` contains the ID of an
>       experiment. Replace `$expid` by that value in the next
>       commands.

The next command is to prepare the experiment workflow (i.e.
parse the configuration and produce a workflow graph, prepare
jobs, etc.):

```bash
autosubmit create $expid
```

If everything goes well you should see the workflow graph plot
appear on your screen, if you have an X server running. Close the
PDF and run the workflow.

```bash
autosubmit run $expid
```

That will execute the complete workflow of your Autosubmit
experiment. If you used `nohup`, or if you have another
command-line terminal, you can monitor the execution of
the workflow with the following commands:

```bash
# plot a new PDF with the progress of your workflow
autosubmit monitor $expid
# print the output logs of your workflow
autosubmit cat-log --file o $expid
# print the error logs of your workflow, in `tail -f` mode
autosubmit cat-log --file o --mode e $expid
```

And if you are using a version of Autosubmit that supports
RO-Crate, you can create an archive with the provenance
metadata file, the workflow configuration, plots, logs, and
other traces included.

```bash
autosubmit archive --rocrate $expid
```

> NOTE: If you use RO-Crate, you will have to provide a
>       JSON-LD file with extra metadata about your
>       experiment and workflow to have a more complete
>       RO-Crate file (using the Workflow Run Crate Profile).

## RO-Crate

TODO: document the `rocrate.json` used to help populating the
`ro-crate-metadata.json` (partials, with license, author, inputs,
and outputs)…

## License

This workflow is licensed under the Apache License v2. You can
read the license at the [`LICENSE.txt`][license] file.

The license applies only to the workflow configuration and code,
and not to the rest of the code and tools used.

Please, note that:

- Autosubmit is licensed under the GNU Public License v3.
- mHM is licensed under the GNU Public License v3.

[autosubmit]: https://autosubmit.readthedocs.io/
[mhm]: https://mhm.pages.ufz.de/mhm/stable/
[dockerfile]: ./Dockerfile
[license]: ./LICENSE.txt
[plotpy]: ./plot.py
