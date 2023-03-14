using Pkg
Pkg.activate(".")
using GLMakie, CairoMakie 
using Printf, GPCC, JLD2, Distributions, DelimitedFiles, KernelDensity


function createplots_joint_marginals()

    #--------------#
    # setup figure #
    #--------------#

    GLMakie.activate!()

    fig = Figure(resolution = (3400, 1200), fontsize = 72)

    display(fig) 


    #--------------#
    # load results #
    #--------------#

    delays, loglikel = JLD2.load("three_lightcurves_joint.jld2", "candidatedelays", "loglikel")


    #------------#
    # setup axes #
    #------------#


    ax = Axis(fig[1, 1], title = "posteriors from joint estimation", xlabel = L"\tau\:\textrm{(days)}", ylabel = L"\mathbf{\pi}_i", xticklabelsize = 40, ylabelsize = 50)
        
    ax.xticks = 0:0.5:10
    ax.yticks = 0.05:0.05:0.15

    #----------------------#
    # calculate posteriors #
    #----------------------#

    posterior = getprobabilities(reduce(vcat, loglikel))

    posterior = reshape(posterior, length(delays), length(delays));


    #-------------------------------#
    # plot posteriors               3
    #-------------------------------#
    # 1st light curve is at 5100 Å
    # 2nd light curve is at 7700 Å
    # 3rd light curve is at 9100 Å
    #-------------------------------#

    # to get posterior for delay between 1st and 2nd light curve use sum(posterior,dims=2)
    posterior12 = vec(sum(posterior,dims=2))

    # to get posterior for delay between 1st and 3rd light curve use sum(posterior,dims=1)
    posterior13 = vec(sum(posterior,dims=1))

    posterior23 = let

        categorical12 = Categorical(posterior12)
        categorical13 = Categorical(posterior13)

        @printf("To get posterior delay between light curves 2 and 3 subtract delays τ12 from τ13, i.e. τ13-τ12\n")
    
        # generate samples of inbetween delay by subtracting samples of one from the other delay
        samples = [(delays[rand(categorical13)] - delays[rand(categorical12)]) for _ in 1:1_000_000]
        
        # estimate density with kernel density estimation
        marginal23 = kde(samples)

        # discretise density and normalise on same grid of delays
        vec(pdf(marginal23, delays) / sum(pdf(marginal23, delays)))

    end

    lines!(ax, delays, posterior12, linewidth=6, color=:red,    label= L"\textrm{ delay between 5100}\AA \textrm{ and 7700}\AA\textrm{, } \tau_2")
    lines!(ax, delays, posterior13, linewidth=6, color=:blue,   label= L"\textrm{ delay between 5100}\AA \textrm{ and 9100}\AA\textrm{, } \tau_3")
    lines!(ax, delays, posterior23, linewidth=6, color=:black,  label= L"\textrm{ delay between 7700}\AA \textrm{ and 9100}\AA")

    

    #-----------------#
    # print out means #
    #-----------------#

    μ12 = sum(posterior12 .* delays)
    σ12 = sum((delays .- μ12).^2 .* posterior12)
    
    @printf("Mean and std delay between 1st and 2nd light curve is \t %.3f\t %.3f\n", μ12, σ12)

    μ13 = sum(posterior13 .* delays)
    σ13 = sum((delays .- μ13).^2 .* posterior13)

    @printf("Mean and std delay between 1st and 3rd light curve is \t %.3f\t %.3f\n", μ13, σ13)

    μ23 = sum(posterior23 .* delays)
    σ23 = sum((delays .- μ23).^2 .* posterior23)

    @printf("Mean and std delay between 2nd and 3rd light curve is \t %.3f\t %.3f\n", μ23, σ23)


    #------------------------------#
    # annotate with means and stds #
    #------------------------------#

    # mean and std for posterior 12
    annotations!(@sprintf("%.2f ±%.2f", μ12, σ12), color=:red,  textsize = 52, position = (μ12, posterior12[argmin(abs.(μ12 .- delays))]))

    # mean and std for posterior 13
    annotations!(@sprintf("%.2f ±%.2f", μ13, σ13), color=:blue, textsize = 52, position = (μ13, posterior13[argmin(abs.(μ13 .- delays))]))

    # mean and std for posterior 23
    annotations!(@sprintf("%.2f ±%.2f", μ23, σ23), color=:black,textsize = 52, position = (μ23, posterior23[argmin(abs.(μ23 .- delays))]))


    #----------------------------#
    # Adjust axes and legend box #
    #----------------------------#

    xlims!(ax, 0, 10.2)
    ylims!(ax, 0, 0.182)

    axislegend(framevisible = false)


    #---------------------#
    # save figure in file #
    #---------------------#

    filenamefig = "marginals_from_joint_posterior_Mgc0811.png"

    @printf("Saving figure in file %s\n", filenamefig)

    CairoMakie.activate!() ; save(filenamefig, fig) ; GLMakie.activate!()


    nothing
end

createplots_joint_marginals()