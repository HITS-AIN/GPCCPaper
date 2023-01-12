#
# If problem with CairoMakie, then start with
# LD_LIBRARY_PATH="" julia -O3 
#
using Pkg
Pkg.activate(".")
using GLMakie, CairoMakie # ❗ important that Makie is imported first 
using GPCC, Printf, JLD2


function createplotforsynthposteriors()

    GLMakie.activate!()
    
    fig = GLMakie.Figure(resolution = (1800, 2400), fontsize = 36)

    GLMakie.Label(fig[0, 1:2], text = "Synthetic data", textsize = 46)

    display(fig) 

    GL = fig[1:4, 1:2] = GridLayout()

    for (index, σ) in enumerate([0.1; 0.5; 1.0; 1.5])

        
        # Plot simulated data in left column
        
        tobs, yobs, __σobs__UNUSED = simulatetwolightcurves(σ=σ)
        
        ax1 = Axis(GL[index, 1], xlabel = "Time (days)", ylabel = "Flux", xticklabelsize = 28)
        
        GLMakie.scatter!(ax1, tobs[1], yobs[1], color=:blue, markersize=18)
        
        GLMakie.scatter!(ax1, tobs[2], yobs[2], color=:red, markersize=18)
        


        # Plot delay posterior in right column
        
        filename = @sprintf("results_synthetic_%.2f.jld2", σ)
        
        @printf("Loading file %s\n", filename)
        
        results, delays = JLD2.load(filename, "loglikel", "delays")
        
        ax2 = GLMakie.Axis(GL[index, 2], xlabel = "τ (days)", ylabel = L"\mathbf{\pi}_i", xticklabelsize = 28, ylabelsize = 44)
        
        GLMakie.lines!(ax2, delays, getprobabilities(results), linewidth=4, color=:black)

        ax2.xticks = LinearTicks(20)

        GLMakie.Label(GL[index, 1:2, Top()], @sprintf("σ = %0.2f", σ), valign = :bottom, padding = (0, 0, 35, 0))
        
    end
    

    filename = "synth_posteriors.png"
    
    @printf("Saving plot in file %s\n", filename)

    CairoMakie.activate!() ; save(filename, fig) ; GLMakie.activate!()

    return fig

end

fig = createplotforsynthposteriors()