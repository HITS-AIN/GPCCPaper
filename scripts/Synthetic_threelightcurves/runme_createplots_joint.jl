using Pkg
Pkg.activate(".")
using GLMakie, CairoMakie 
using Printf, GPCC, JLD2, Distributions, DelimitedFiles, StatsFuns, KernelDensity


function createplots_joint()


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

    @printf("To get posterior delay between light curves 1 and 2 use vec(sum(posterior_joint,dims=2))\n")

    posterior12 = vec(sum(posterior_joint,dims=2))

    @printf("To get posterior delay between light curves 1 and 3 use vec(sum(posterior_joint,dims=1))\n")
    
    posterior13 = vec(sum(posterior_joint,dims=1))

    categorical12 = Categorical(posterior12)
    categorical13 = Categorical(posterior13)

    posterior23 = let

        @printf("To get posterior delay between light curves 2 and 3 subtract delays τ12 from τ13, i.e. τ13-τ12\n")
    
        # generate samples of inbetween delay by subtracting samples of one from the other delay
        samples = [(delays[rand(categorical13)] - delays[rand(categorical12)]) for _ in 1:1_000_000]
        
        # estimate density with kernel density estimation
        marginal23 = kde(samples)

        # discretise density and normalise on same grid of delays
        vec(pdf(marginal23, delays) / sum(pdf(marginal23, delays)))

    end

    GLMakie.lines!(ax, delays, posterior12, linewidth=4, color=:red,   label="marginal delay between 1, 2")
    GLMakie.lines!(ax, delays, posterior13, linewidth=4, color=:black, label="marginal delay between 1, 3")
    GLMakie.lines!(ax, delays, posterior23, linewidth=4, color=:blue,  label="marginal delay between 2, 3")


    #-------------------------------------------#
    # Print out mean of marginals distributions #
    #-------------------------------------------#

    @printf("Mean of posterior12 is \t %.3f\n", sum(posterior12.*delays))
    @printf("Mean of posterior13 is \t %.3f\n", sum(posterior13.*delays))
    @printf("Mean of posterior23 is \t %.3f\n", sum(posterior23.*delays))


    #---------------------#
    # Save figure in file #
    #---------------------#

    filenamefig = "marginals_from_joint.png"

    @printf("Saving figure in file %s\n", filenamefig)

    CairoMakie.activate!() ; save(filenamefig, fig) ; GLMakie.activate!()


    axislegend(framevisible = false)
   
    fig

end

createplots_joint()