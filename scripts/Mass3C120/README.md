### Contents of directory

This directory contains code that reproduces the plots for the mass of objecti 3C120.

The scripts below should take care of computing the results and creating plots.

### Installing relevant packages

If the Julia packages necessary for running these scripts are not present in your system, you can install them by:

1. Starting Julia in the directory where the scripts are located.
2. Switch to package mode with `]` and activate the local environment with `activate .`
3. Still within package model execute ``instantiate``.

It may take considerable time for Julia to install the necessary packages.

### Running the scripts

By simply using in the julia REPL:
```
include("runme.jl")
```
the relevant will be produced and saved as PNG files. Also the samples of drawn to construct our grey histograms will be saved as CSV files.


