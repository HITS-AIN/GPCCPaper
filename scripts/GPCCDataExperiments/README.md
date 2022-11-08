This directory contains code that reproduces the results and plots for the objects 3C120, Mrk335, Mrk6, Mrk1501, PG2130099.


The scripts below should take care of installing all relevant software necessary for computing the results and creating plots.


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
it should be possible to recreate the plots that shows the posterior delay distributions in the paper.


