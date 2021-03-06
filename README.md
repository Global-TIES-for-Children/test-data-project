
<!-- README.md is generated from README.Rmd. Please edit that file -->

# testdataproject

This project serves as a template for TIES data processing projects:
using [{drake}](https://github.com/ropensci/drake) (or
[{targets}](https://github.com/ropensci/targets)) for workflow
management, using Github Actions for CI/CD, and using the [Open Science
Framework (OSF)](https://osf.io) as a data/resources storage interface.
This project is linked to [this OSF project](https://osf.io/p74bc/).

### Layout

    .github/
      workflows/
        .. All Github Actions workflows ..
    config/
      packages.R  # All packges you want to attach for your work
      plan.R      # The {drake} plan file
    R/
      .. All supplemental R function definitions ..
    tests/
      .. Unit tests on function definitions ..
    _drake.R      # {drake} configuration file
    DESCRIPTION   # Project metadata (R package format)
    install.R     # Script that installs required packages
    make.R        # Master script that runs Drake

### CI/CD Workflows

This project has two CI/CD workflows that run:

1.  `build-project`: Runs on push or pull request to `main` or any
    `staging/*` branch. As implied by the name, this workflow builds the
    project. It also runs any unit tests defined in the “tests” folder.
    This workflow is intended to be used as a check on the submitted
    code.
2.  `export-data`: Runs when a commit is tagged with `v*`. This workflow
    runs `build-project` with a signal to upload assets defined in the
    {drake} plan to the OSF

# Installation

To use this project, in a terminal environment:

1.  `git clone` this repo
2.  `cd` to where you downloaded this repo
3.  `Rscript install.R` to install the required software
4.  `Rscript make.R` to run the project workflow
