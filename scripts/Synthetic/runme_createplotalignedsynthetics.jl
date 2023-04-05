using Pkg
Pkg.activate(".")
Pkg.instantiate()
using GLMakie, CairoMakie # ❗ important that Makie is imported first 
using GPCC, Printf, JLD2
using Statistics, StatsFuns

function createplotalignedsynthetics()

    GLMakie.activate!()

    fig = GLMakie.Figure(resolution = (3600, 1000), fontsize = 44)
   
    tobs, yobs, σobs = simulatetwolightcurves(σ=1.0)

    GLMakie.Label(fig[0, 1:3], text = "Aligned synthetic lightcurves", textsize = 46)

    display(fig) 

    GL = fig[1:1, 1:3] = GridLayout()

   
    delays = [2;16.8;20]
    
    for (i,d) in enumerate(delays)

        minopt, pred, (α, posterioroffsetb, ρ) = gpcc(tobs, yobs, σobs;
        kernel = GPCC.OU, delays = [0; d], iterations = 1000, numberofrestarts = 7,
        initialrandom=1, rhomin = 0.1, rhomax = 1000)

        b = mean(posterioroffsetb)

        ax1 = Axis(GL[1, i], xlabel = "Time (days)", ylabel = "Flux (arbitrary units)",  ylabelsize = 30, xgridvisible = false, ygridvisible = false)

        
        GLMakie.scatter!(ax1, tobs[1] .- 0.0, 1 / α[1] * (yobs[1] .- b[1]), color=:blue, markersize=24)

        GLMakie.scatter!(ax1, tobs[2] .-   d, 1 / α[2] * (yobs[2] .- b[2]), color=:red, markersize=24)


        trange = minimum(min(tobs[1], tobs[2] .- d)):0.01:maximum(max(tobs[1], tobs[2] .- d))
        
        GLMakie.lines!(ax1, trange, 1 / α[1] * (pred(trange)[1][1] .- b[1]), linewidth=6, color="black")
    
        ylims!(ax1, -4, 4)

    end

    filename = "synth_aligned_at_three_delays.png"
    
    @printf("Saving plot in file %s\n", filename)

    CairoMakie.activate!() ; save(filename, fig) ; GLMakie.activate!()

    return fig

end


fig = createplotalignedsynthetics()