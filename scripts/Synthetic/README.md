This directory contains code that reproduces the results and plots for the synthetic simulations.


The scripts to be executed below should be able to take care of installing all relevant software necessary for computing the results and creating plots.


By simply using in the julia REPL:
```
include("runme.jl")
```
you will compute all the posterior delay distributions. 
The results will be saved in files that use the JLD2 format.


Once the results have been computed and saved, by using in the julia REPL:
```
include("runme_createplotforsynthposteriors.jl")
```
it should be possible to recreate the plot that shows the posterior delay distributions in the paper.


Similarly, with:
```
include("runme_createplotalignedsynthetics.jl")
```
it should be possible to recreate the plot that shows the posterior delay distributions in the paper.