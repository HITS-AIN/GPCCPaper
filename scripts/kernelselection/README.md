### Contents of directory

This directory contains code that reproduces the results and plots for the kernel selection application via CV for objects 3C120 and Mrk6.

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
you will compute all cross-validations.
The results will be saved in files that use the JLD2 format.

❗ This is a lengthy computation, best run on a larger number of workers, preferrably in a cluster environment!

Once the results have been computed and saved, by using in the julia REPL:
```
include("runme_createplots.jl")
```
it should be possible to recreate the plots that show the cross-validation performance in the paper.

The values displayed in the plots are also saved in CSV files with self-explanatory filenames.


