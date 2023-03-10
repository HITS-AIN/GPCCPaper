using Pkg
Pkg.activate(".")
using GLMakie, CairoMakie 
using Printf, GPCC, JLD2, Distributions, DelimitedFiles, StatsFuns, KernelDensity


function createplots()

    # setup figure

    GLMakie.activate!()

    fig = GLMakie.Figure(resolution = (1800, 1800), fontsize = 44)

    display(fig) 


    # load results

    candidatedelays_joint, loglikel_joint = JLD2.load("results_synthetic_threelightcurves_joint.jld2", "candidatedelays", "loglikel")

 
    # calculate posteriors

    posterior_joint = getprobabilities(reduce(vcat, loglikel_joint))

    posterior_joint = reshape(posterior_joint, length(candidatedelays_joint), length(candidatedelays_joint));


    # #--------------------------------------------------#
    # # Plot marginals inferred from joint distributions #
    # #--------------------------------------------------#

    marginal12 = Categorical(vec(sum(posterior_joint,dims=2)))
    marginal13 = Categorical(vec(sum(posterior_joint,dims=1)))
    samples = [candidatedelays_joint[rand(marginal13)] - candidatedelays_joint[rand(marginal12)] for _ in 1:1_000_000]
    marginal23 = kde(samples)

    GLMakie.lines!(ax, candidatedelays_joint, vec(sum(posterior_joint,dims=1)), linewidth=4, color=:red,  linestyle = :dash, label="marginal delay between 1, 2")
    GLMakie.lines!(ax, candidatedelays_joint, vec(sum(posterior_joint,dims=2)), linewidth=4, color=:black,    linestyle = :dash, label="marginal delay between 1, 3")
    GLMakie.lines!(ax, candidatedelays_joint, vec(pdf(marginal23, candidatedelays_joint)/sum(pdf(marginal23, candidatedelays_joint))), linewidth=4, color=:blue, linestyle = :dash, label="marginal delay between 2, 3")

    axislegend(framevisible = false)

    # nothing
    fig
    # samples
end

createplots()