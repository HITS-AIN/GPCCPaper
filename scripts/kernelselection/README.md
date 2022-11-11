This directory contains code that reproduces the results and plots for the kernel selection application via CV for objects 3C120 and Mrk6.


The scripts below should take care of installing all relevant software necessary for computing the results and creating plots.


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
it should be possible to recreate the plots that show the posterior delay distributions in the paper.

The values displayed in the plots are also saved in CSV files with self-explanatory filenames.


