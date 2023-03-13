using Pkg
Pkg.activate(".")
using GLMakie, CairoMakie 
using Printf, GPCC, JLD2, Distributions, DelimitedFiles, StatsFuns, KernelDensity


function createplots_pairwise()

        #--------------#
        # setup figure #
        #--------------#

        GLMakie.activate!()

        fig = GLMakie.Figure(resolution = (3400, 1000), fontsize = 44)
    
        display(fig) 
    
    
        #------------------------------------------------#
        # Load pairwise results and calculate posteriors #
        #------------------------------------------------#
    
        delays_pair, l12, l13, l23  = JLD2.load("three_lightcurves_pairwise.jld2", "candidatedelays", "loglikel12", "loglikel13", "loglikel23")
    
        posterior12 = exp.(l12 .- logsumexp(l12))
        posterior13 = exp.(l13 .- logsumexp(l13))
        posterior23 = exp.(l23 .- logsumexp(l23))
    

        #---------------------------------------------#
        # Plot pairwise posterior delay distributions #
        #---------------------------------------------#
    
        ax = GLMakie.Axis(fig[1, 1], xlabel = L"\tau\:\textrm{(days)}", ylabel = L"\mathbf{\pi}_i", xticklabelsize = 28, ylabelsize = 44)
        
        ax.xticks = 0:0.5:10
    
        GLMakie.lines!(ax, delays_pair, posterior12, linewidth=6, color=:black, label= L"\textrm{ delay between 5100}\AA \textrm{ and 7700}\AA\textrm{, } \tau_2")
        GLMakie.lines!(ax, delays_pair, posterior13, linewidth=6, color=:red,   label= L"\textrm{ delay between 5100}\AA \textrm{ and 9100}\AA\textrm{, } \tau_3")
        GLMakie.lines!(ax, delays_pair, posterior23, linewidth=6, color=:blue,  label= L"\textrm{ delay between 7700}\AA \textrm{ and 9100}\AA")
    
        
        #---------------------------------------------------#
        # Calculate posterior means and standard deviations #
        #---------------------------------------------------#
    
        μ12 = sum(delays_pair.*posterior12)
        σ12 = sqrt(sum((delays_pair .- μ12).^2.0 .* posterior12))

        μ13 = sum(delays_pair.*posterior13)
        σ13 = sqrt(sum((delays_pair .- μ13).^2.0 .* posterior13))

        μ23 = sum(delays_pair.*posterior23)
        σ23 = sqrt(sum((delays_pair .- μ23).^2.0 .* posterior23))

        @printf("Mean and std of delay between 1, 2\t μ=%.4f \t σ=%.4f\n", μ12, σ12)
        @printf("Mean and std of delay between 1, 3\t μ=%.4f \t σ=%.4f\n", μ13, σ13)
        @printf("Mean and std of delay between 2, 3\t μ=%.4f \t σ=%.4f\n", μ23, σ23)


        #----------------------------#
        # Adjust axes and legend box #
        #----------------------------#

        xlims!(ax, 0, 4.2)

        axislegend(framevisible = false)
        

        #---------------------#
        # save figure in file #
        #---------------------#

        filenamefig = "pairwise_delays_Mgc0811.png"

        @printf("Saving figure in file %s\n", filenamefig)

        CairoMakie.activate!() ; save(filenamefig, fig) ; GLMakie.activate!()


        fig
end


createplots_pairwise()