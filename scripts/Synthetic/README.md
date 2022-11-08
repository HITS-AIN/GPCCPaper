This directory contains code that reproduces the results and plots for the synthetic simulations.

The code reproduces the following two plots:
<p align="center">

<img src="https://github.com/HITS-AIN/GPCCPaper/blob/b2d946d8f6fc5cb27f9af5c0c800a61209c2024d/scripts/Synthetic/synth_aligned_at_three_delays.png"  style="width:1000px;height:300px;">
<img src="https://github.com/HITS-AIN/GPCCPaper/blob/b2d946d8f6fc5cb27f9af5c0c800a61209c2024d/scripts/Synthetic/synth_posteriors.png"  style="width:350px;height:400px;">

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
include("runme_createplotforsynthposteriors.jl")
```
it should be possible to recreate the plot that shows the posterior delay distributions in the paper.


Similarly, with:
```
include("runme_createplotalignedsynthetics.jl")
```
it should be possible to recreate the plot that shows the posterior delay distributions in the paper.


