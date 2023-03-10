using Pkg
Pkg.activate(".")
using GLMakie, CairoMakie 
using Printf, GPCC, JLD2, Distributions, DelimitedFiles, StatsFuns, KernelDensity


function createplots()

    #--------------#
    # setup figure #
    #--------------#

    GLMakie.activate!()

    fig = GLMakie.Figure(resolution = (1800, 1800), fontsize = 44)

    display(fig) 

    ax = GLMakie.Axis(fig[1, 1], xlabel = L"\tau\:\textrm{(days)}", ylabel = L"\mathbf{\pi}_i", xticklabelsize = 28, ylabelsize = 44)
    
    ax.xticks = 0:0.5:11
   

    #--------------#
    # load results #
    #--------------#

    delays, loglikel_joint = JLD2.load("results_synthetic_threelightcurves_joint.jld2", "candidatedelays", "loglikel")


    #----------------------#
    # calculate posteriors #
    #----------------------#

    posterior_joint = getprobabilities(reduce(vcat, loglikel_joint))

    posterior_joint = reshape(posterior_joint, length(delays), length(delays));


    #--------------------------------------------------#
    # Plot marginals inferred from joint distributions #
    #--------------------------------------------------#

    marginal12 = Categorical(vec(sum(posterior_joint,dims=2)))
    marginal13 = Categorical(vec(sum(posterior_joint,dims=1)))
    samples = [(delays[rand(marginal13)] - delays[rand(marginal12)]) for _ in 1:1_000_000]
    marginal23 = kde(samples)

    GLMakie.lines!(ax, delays, vec(sum(posterior_joint,dims=1)), linewidth=4, color=:red,  label="marginal delay between 1, 2")
    GLMakie.lines!(ax, delays, vec(sum(posterior_joint,dims=2)), linewidth=4, color=:black,    label="marginal delay between 1, 3")
    GLMakie.lines!(ax, delays, vec(pdf(marginal23, delays)/sum(pdf(marginal23, delays))), linewidth=4, color=:blue, label="marginal delay between 2, 3")


    axislegend(framevisible = false)
   
    fig

end

createplots()