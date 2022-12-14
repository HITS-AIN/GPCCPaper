### Contents of directory

This directory contains code that reproduces the results and plots for the synthetic simulations.

The code reproduces the following  plot:


<p align="center">

<img src="https://github.com/HITS-AIN/GPCCPaper/blob/40374013f67025aff7c04371b4ab6ebbb1dcb398/scripts/threelightcurves/2Dposterior_Mgc0811.png"  style="width:500px;height:500px;">

</p>

### Installing relevant packages

If the Julia packages necessary for running these scripts are not present in your system, you can install them by:

1. Starting Julia in the directory where the scripts are located.
2. Switch to package mode with `]` and activate the local environment with `activate .`
3. Still within package model execute ``instantiate``.

It may take considerable time for Julia to install the necessary packages.

### Running the scripts

The scripts below should take care of  computing the results and creating plots.


By simply using in the julia REPL:
```
include("runme.jl")
```
you will compute all the posterior delay distributions. 
The results will be saved in files that use the JLD2 format.

❗ This is a lengthy computation, best run on a larger number of workers, preferrably in a cluster environment!


Once the results have been computed and saved, by using in the julia REPL:
```
include("runme_createplots.jl")
```
it should be possible to recreate the plot that shows the posterior delay distributions in the paper.

The values of the candidate delays and the values of the joint posterior are saved in CSV files.
