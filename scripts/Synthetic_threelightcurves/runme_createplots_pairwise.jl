using Pkg
Pkg.activate(".")
using GLMakie, CairoMakie 
using Printf, GPCC, JLD2, Distributions, DelimitedFiles, StatsFuns, KernelDensity


function createplots_pairwise()

    # setup figure

    GLMakie.activate!()

    fig = GLMakie.Figure(resolution = (1800, 1800), fontsize = 44)

    display(fig) 

    # load results

    delays, l12, l13, l23 = JLD2.load("results_synthetic_threelightcurves_pairwise.jld2", "candidatedelays", "loglikel12", "loglikel13", "loglikel23")

    posterior12 = exp.(l12 .- logsumexp(l12))
    posterior13 = exp.(l13 .- logsumexp(l13))
    posterior23 = exp.(l23 .- logsumexp(l23))

    cat12 = Categorical(posterior12)
    cat13 = Categorical(posterior13)

    #------------------------------------------------------#
    # Plot pairwise inferred posterior delay distributions #
    #------------------------------------------------------#

    ax = GLMakie.Axis(fig[1, 1], xlabel = L"\tau\:\textrm{(days)}", ylabel = L"\mathbf{\pi}_i", xticklabelsize = 28, ylabelsize = 44)
    
    ax.xticks = 0:0.5:8

    GLMakie.lines!(ax, delays, posterior12, linewidth=4, color=:black, label="pairwise delay between 1, 2")
    GLMakie.lines!(ax, delays, posterior13, linewidth=4, color=:red,   label="pairwise delay between 1, 3")
    GLMakie.lines!(ax, delays, posterior23, linewidth=4, color=:blue,  label="pairwise delay between 2, 3")

    let

        samples = [delays[rand(cat13)] - delays[rand(cat12)] for _ in 1:1_000_000]
        c23pdf = kde(samples)
        GLMakie.lines!(ax, delays, vec(pdf(c23pdf, delays)/sum(pdf(c23pdf, delays))), linewidth=6, color=:cyan, label="inferred")

    end

    axislegend(framevisible = false)

    fig

end

createplots_pairwise()