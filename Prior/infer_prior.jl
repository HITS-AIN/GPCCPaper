
#
# Run this script to infer prior distribution for objects with z <= 0.2
# The prior is in the variable 'τpdfnet'
# It has also been stored in file "prior_z_0.2.jld2" as a LinearInterpolation object
# Use loadprior_z_0_2 to access the prior as a function
#

#-----------------------------------#
#       Load packages and code      #
#-----------------------------------#

using Pkg
Pkg.activate(".")
using FITSIO, KernelDensity
using StatsFuns, StatsBase, Statistics, Optim
using Printf, PyPlot, Distributions, ForwardDiff
using ForwardNeuralNetworks, Interpolations

include("readdata.jl")
include("prior1.jl")
include("approximate_cdf_prior_with_net.jl")


#-----------------------------------#
# load data with redshift up to 0.2 #
#-----------------------------------#

observedparameters = readdatagivenz(0.0, 0.2)[:,1:2]


#---------------------------------------------#
# convert observed quantities to upper delays #
#---------------------------------------------#

τupper = let 

    zobs = 0.02

    edfracobs = (10.0.^observedparameters[:,1]) * 100

    bhmobs    = 10.0.^observedparameters[:,2]

    [getupperdelay_conditional(; z = zobs, bhm = bhmobs[i], edfrac = edfracobs[i], eta = 0.1) for i in 1:size(observedparameters, 1)]
    
end


#---------------------------------------------#
# sample delays and perform KDE               #
#---------------------------------------------#

τsample = [rand()*τupper[ceil(Int, rand()*length(τupper))] for i in 1:1_000_000]


τpdf = kde_lscv(τsample)


#---------------------------------------------#
# plot estimated pdf                          #
#---------------------------------------------#

let 

    figure(); title("pdf")
    
    τrange = collect(0:0.05:maximum(τsample))
    
    plot(τrange, pdf(τpdf, τrange), label = "prior"); legend()

end



###############################################
# ❗ Second approximation of delay density ❗ #
###############################################

#--------------------------------------------#
# empirical cdf and continuous approximation #
#--------------------------------------------#

τcdf = ecdf(τsample)

τcdfcont = let 
    
    # warmup
    approximate_cdf_prior_with_net(collect(0:0.05:maximum(τsample)), τcdf; maxiter=2)

    # approximate cdf, we do this in order to smooth the empirical cdf
    approximate_cdf_prior_with_net(collect(0:0.05:maximum(τsample)), τcdf; maxiter=6_000)

end

τpdfnet(x) = ForwardDiff.derivative(τcdfcont, x)


#---------------------------------------------#
# plot cdf and pdf                            #
#---------------------------------------------#

let 

    figure()

    τrange = collect(0:0.05:maximum(τsample))

    subplot(211)
    title("cdf")
    plot(τrange, τcdf.(τrange), label = "ecdf")
    plot(τrange, τcdfcont.(τrange), label = "nn")

    subplot(212)
    title("pdf")
    plot(τrange, τpdfnet.(τrange), label = "pdf nn")

end