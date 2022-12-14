### Contents of directory

This directory contains code that reproduces the results and plots for the objects 3C120, Mrk335, Mrk6, Mrk1501, PG2130099.

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
you will compute all the posterior delay distributions. 
The results will be saved in files that use the JLD2 format.


Once the results have been computed and saved, by using in the julia REPL:
```
include("runme_produceposteriorplots.jl")
```
it should be possible to recreate the plots that show the posterior delay distributions in the paper.

The values displayed in the plots are also saved in CSV files with self-explanatory filenames.


