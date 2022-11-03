#
# If problem with CairoMakie, then start with
# LD_LIBRARY_PATH="" nice ~/julia-1.7.3/bin/julia -O3 
#
using GLMakie, CairoMakie # ❗ important that Makie is imported first 
using GPCC, Printf, JLD2


# Use this to save figure
# CairoMakie.activate!() ; save(figname, fig) ; GLMakie.activate!()

function plotsyntheticresults()

    GLMakie.activate!()
    
    fig = GLMakie.Figure(resolution = (1800, 2400), fontsize = 38)

    GLMakie.Label(fig[0, 1:2], text = "Synthetic data", textsize = 46)

    display(fig) 

    GL = fig[1:4, 1:2] = GridLayout()

    for (index, σ) in enumerate([0.1; 0.5; 1.0; 1.5]) # left out σ=0.01, σ=0.2.

        
        # Plot simulated data
        
        tobs, yobs, __σobs__UNUSED = simulatetwolightcurves(σ=σ)
        
        ax1 = Axis(GL[index, 1], xlabel = "Days", ylabel = "Flux")
        
        GLMakie.scatter!(ax1, tobs[1], yobs[1], color=:blue, markersize=18)
        
        GLMakie.scatter!(ax1, tobs[2], yobs[2], color=:red, markersize=18)
        


        # Plot delay posterior
        
        filename = @sprintf("results_synthetic_%.2f.jld2", σ)
        
        @printf("Loading file %s\n", filename)
        
        results, delays = JLD2.load(filename, "loglikel", "delays")
        
        ax2 = GLMakie.Axis(GL[index, 2], xlabel = "τ (days)", ylabel = L"\mathbf{\pi}", ylabelsize = 44)
        
        GLMakie.lines!(ax2, delays, getprobabilities(results), linewidth=4)

        ax2.xticks = LinearTicks(20)

        GLMakie.Label(GL[index, 1:2, Top()], @sprintf("Experiment %d: σ = %0.2f", index, σ), valign = :bottom, padding = (0, 0, 35, 0))
        
    end
    
    fig

end
