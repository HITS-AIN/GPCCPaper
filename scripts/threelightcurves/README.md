This directory contains code that reproduces the results and plots for the synthetic simulations.

The code reproduces the following  plot:


<p align="center">

<img src="https://github.com/HITS-AIN/GPCCPaper/blob/2c7fc0a8ea5244d06043382e03432a08225ed0fd/scripts/threelightcurves/2Dposterior_Mgc0811.png"  style="width:500px;height:500px;">

</p>


The scripts below should take care of installing all relevant software necessary for computing the results and creating plots.


By simply using in the julia REPL:
```
include("runme.jl")
```
you will compute all the posterior delay distributions. 
The results will be saved in files that use the JLD2 format.


Once the results have been computed and saved, by using in the julia REPL:
```
include("runme_createplots.jl")
```
it should be possible to recreate the plot that shows the posterior delay distributions in the paper.
