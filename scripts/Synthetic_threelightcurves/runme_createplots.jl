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

    candidatedelays_pair, l12, l13, l23  = JLD2.load("results_synthetic_threelightcurves_pairwise.jld2", "candidatedelays", "loglikel12","loglikel13","loglikel23")

    posterior12 = exp.(l12 .- logsumexp(l12))
    posterior13 = exp.(l13 .- logsumexp(l13))
    posterior23 = exp.(l23 .- logsumexp(l23))

    # calculate posteriors

    posterior_joint = getprobabilities(reduce(vcat, loglikel_joint))

    posterior_joint = reshape(posterior_joint, length(candidatedelays_joint), length(candidatedelays_joint));


    #------------------------------------------------------#
    # Plot pairwise inferred posterior delay distributions #
    #------------------------------------------------------#

    ax = GLMakie.Axis(fig[1, 1], xlabel = L"\tau\:\textrm{(days)}", ylabel = L"\mathbf{\pi}_i", xticklabelsize = 28, ylabelsize = 44)
    
    ax.xticks = 0:0.5:8

    # GLMakie.lines!(ax, collect(candidatedelays_pair), posterior12, linewidth=4, color=:black, label="pairwise delay between 1, 2")
    # GLMakie.lines!(ax, collect(candidatedelays_pair), posterior13, linewidth=4, color=:red,   label="pairwise delay between 1, 3")
    # GLMakie.lines!(ax, collect(candidatedelays_pair), posterior23, linewidth=4, color=:blue,  label="pairwise delay between 2, 3")

    # let
    #     c12 = Categorical(posterior12)
    #     c13 = Categorical(posterior13)
    #     samples = [candidatedelays_pair[rand(c13)] - candidatedelays_pair[rand(c12)] for _ in 1:1_000_000]
    #     c23pdf = kde(samples)
    #     GLMakie.lines!(ax, candidatedelays_pair, vec(pdf(c23pdf, candidatedelays_pair)/sum(pdf(c23pdf, candidatedelays_pair))), linewidth=6, color=:cyan, linestyle = :dashdot, label="sss")

    # end


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