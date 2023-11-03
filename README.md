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

[![DOI](https://zenodo.org/badge/624628558.svg)](https://zenodo.org/badge/latestdoi/624628558)

# Autosubmit mHM workflow with mHM test domains data

This repository contains the configuration for an [Autosubmit][autosubmit]
experiment that runs [mHM][mhm], the mesoscale hydrological model, using
the mHM test domain data in a workflow. A Docker container is used to install
the dependencies and run mHM.

The two images below were created using the workflow in this
repository, and running the [`plot.py`][plotpy] script (it uses
Xarray and Matplotlib to parse the NetCDF test output).

<div>
  <img src="./docs/plot.gif" style="max-width: 400px;" alt="mHM test domain plot" />
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

In order to run the workflow you will need the following
prerequisites:

1. Internet connection
2. Linux
3. Autosubmit 4.0.98 or greater (e.g. `pip install autosubmit==4.0.98`)
4. Docker & Singularity 3.11.x or greater for running the container
5. ImageMagick's `convert` to generate the GIF animation using the PNG files produced by `plot.py`

For a list of software used, besides `mHM`, see the [`Dockerfile`][dockerfile].

## Build the containers

To build the Docker container image first, use this command.

```bash
sudo docker build --no-cache=true --tag "auto-mhm-test-domains/mhm:v5.12.1.dev228" .
```

Now, to build the Singularity container, using the Docker container image, use this command.

```bash
sudo singularity build --force mhm.sif docker-daemon://auto-mhm-test-domains/mhm:v5.12.1.dev228
```

Now copy the created container `mhm.sif` into the location specified in `conf/mhm.yml`.

**NOTE**: The workflow expects the `mhm.sif` Singularity file to exist
on each platform.

## Workflow

An Autosubmit experiment created with
`autosubmit expid -H <YOUR_PLATFORM> -d "mHM" -min -repo https://github.com/kinow/auto-mhm-test-domains.git -branch master -conf conf/bootstrap`
when run will clone this Git repository, and prepare the Docker
& Singularity containers, transfer all the required data over to
the chosen platform (it can be local for testing) and execute
the mHM model for each start date (as the mHM simulation period date).
The last tasks in the workflow will plot the data before cleaning the
simulation logs and files.

<img src="./docs/mhm-workflow-graph.png" style="max-width: 400px; max-height: 400px;"  alt="mHM workflow graph"/>

The plots are copied back to the local workflow folder, and
everything can be used to package an RO-Crate.

## Running

You will need an Autosubmit experiment first, so that you
can import the configuration files from this Git repository.
Run the following command to create a new Autosubmit experiment.

```bash
autosubmit expid \
    --description "Autosubmit mHM test domains" \
    --minimal_configuration \
    --git_as_conf conf/bootstrap \
    --git_repo https://github.com/kinow/auto-mhm-test-domains.git \
    --git_branch master
```

This will create a new experiment, using SSH connections to the
“local” platform. On the first execution of `autosubmit create`,
it will clone the Git repository specified and load the
configuration from the subdirectory specified in the `git_as_conf`
parameter.

> NOTE: The output of `autosubmit expid` contains the ID of an
> experiment. Replace `<EXPID>` by that value in the next
> commands.

The `platforms.yml` file in this repository contains placeholders
like `<USER>`, `<REMOTE_HOST>`, etc., that must be filled in before
the workflow can be used. Alternatively, you can create the
following file with your platform configuration (replace the
values by your user account information).

```yaml
# File: ~/.config/autosubmit/platforms.yml

PLATFORMS:
  # You can use a different name, just adjust your `autosubmit expid`
  # command and `conf/platforms.yml`, and this other platforms.yml
  # files.
  REMOTE:
    TYPE: ps
    HOST: localhost
    ADD_PROJECT_TO_HOST: false
    SCRATCH_DIR: /tmp/scratch/
    PROJECT: mhm-project
    USER: kinow
```

The next command is to prepare the experiment workflow (i.e.
parse and validate its configuration and produce a workflow graph,
prepare jobs and scripts, etc.):

```bash
autosubmit create <EXPID>
```

If everything goes well you should see the workflow graph plot
appear on your screen (if you have an X server running). Close
the PDF and now run the workflow with the following command:

```bash
autosubmit run <EXPID>
```

That will execute the complete workflow of your Autosubmit
experiment. If you used `nohup`, or if you have another
command-line terminal, you can monitor the execution of
the workflow with the following commands:

```bash
# plot a new PDF with the progress of your workflow
autosubmit monitor <EXPID>
# print the output logs of your workflow
autosubmit cat-log --file o <EXPID>
# print the error logs of your workflow, in `tail -f` mode
autosubmit cat-log --file o --mode e <EXPID>
```

> NOTE: Autosubmit commands produce log files on disk
> for traceability. You can increase the log levels
> with the `-lf` (log file) and `lc` (log console)
> parameter flags.

And if you are using a version of Autosubmit that supports
RO-Crate, you can create an archive with the provenance
metadata file, the workflow configuration, plots, logs, and
other traces included.

```bash
autosubmit archive --rocrate <EXPID>
```

> NOTE: If you use RO-Crate, you will have to provide a
> JSON-LD file with extra metadata about your
> experiment and workflow to have a more complete
> RO-Crate file (using the Workflow Run Crate Profile).

## RO-Crate

This is an example RO-Crate configuration file for this Autosubmit workflow.
You can add this setting anywhere, like `<EXPID>/conf/rocrate.yml`.

```yaml
ROCRATE:
  INPUTS:
    # Add the extra configuration keys to be exported.
    # This one is from the mhm.yml file, we export everything
    # as inputs.
    - "MHM"
  OUTPUTS:
    - "*/*.gif"
  PATCH: |
    {
      "@graph": [
        {
          "@id": "./",
          "license": "Apache-2.0",
          "creator": {
            "@id": "https://orcid.org/0000-0001-8250-4074"
          },
          "publisher": {
            "@id": "https://ror.org/05sd8tv96"
          }
        },
        {
          "@id": "#create-action",
          "@type": "CreateAction",
          "name": "Run mHM",
          "instrument": { "@id": "workflow.yml" },
          "agent": { "@id": "https://orcid.org/0000-0001-8250-4074" }
        },
        {
          "@id": "ro-crate-metadata.json",
          "author": [
            {
              "@id": "https://orcid.org/0000-0001-8250-4074"
            }
          ]
        },
        {
          "@id": "https://orcid.org/0000-0001-8250-4074",
          "@type": "Person",
          "affiliation": {
              "@id": "https://ror.org/05sd8tv96"
          },
          "contactPoint": {
              "@id": "mailto: bruno.depaulakinoshita@bsc.es"
          },
          "name": "Bruno P. Kinoshita"
        },
        {
            "@id": "mailto: bruno.depaulakinoshita@bsc.es",
            "@type": "ContactPoint",
            "contactType": "Author",
            "email": "bruno.depaulakinoshita@bsc.es",
            "identifier": "bruno.depaulakinoshita@bsc.es",
            "url": "https://orcid.org/0000-0001-8250-4074"
        },
        {
            "@id": "https://ror.org/05sd8tv96",
            "@type": "Organization",
            "name": "Barcelona Supercomputing Center"
        }
      ]
    }
```

## License

This workflow is licensed under the GNU General Public License V3. You can
find the complete license at the file [`LICENSE.txt`][license].

The license applies only to the workflow configuration and code,
and not to the rest of the code and tools used.

Please, note that:

- Autosubmit is licensed under the GNU General Public License v3.
- mHM is licensed under the GNU General Public License v3.

[autosubmit]: https://autosubmit.readthedocs.io/

[mhm]: https://mhm.pages.ufz.de/mhm/stable/

[dockerfile]: ./Dockerfile

[license]: ./LICENSE.txt

[plotpy]: ./plot.py
