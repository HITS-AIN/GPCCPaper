using GLMakie, CairoMakie, Statistics, StatsFuns, GPCC

function plotaligned(tobs, yobs, σobs; kernel = kernel, delays = delays, rhomax = rhomax, numberofrestarts = 7, iterations = 1000)

    GLMakie.activate!()

    minopt, pred, (α, posterioroffsetb, ρ) = gpcc(tobs, yobs, σobs;
        kernel = kernel, delays = delays, iterations = iterations, numberofrestarts = numberofrestarts,
        initialrandom=1, rhomin = 0.1, rhomax = rhomax)

    b = mean(posterioroffsetb)

    @assert(length(tobs) == length(yobs) == length(delays) == length(b) == length(α) == 2)

    fig = GLMakie.Figure(resolution=(3840,2400/2),fontsize = 44)

    display(fig) 

    # ax = Axis(fig[1,1],title = "Synthetic curves, σ=0.2, aligned at delay 14.0", xlabel = "days", ylabel = "flux")
    ax = GLMakie.Axis(fig[1,1],title = "", xlabel = "Days", ylabel = "Flux")
    
    # ax.xticks = LinearTicks(30)

    # ax.yticks = LinearTicks(5)

    # xlims!(ax, 0, τmax*1.01) #; ylims!(ax, 0.3, maxy)

    GLMakie.scatter!(ax, tobs[1] .- delays[1], 1 / α[1] * (yobs[1] .- b[1]), color=:blue, markersize=24)

    GLMakie.scatter!(ax, tobs[2] .- delays[2], 1 / α[2] * (yobs[2] .- b[2]), color=:red, markersize=24)


    fig
end


# fig = plotaligned(tobs, yobs,σobs, kernel=GPCC.OU, delays=[0;2], rhomax=1200)
# CairoMakie.activate!() ; save("synth_aligned_at_2.0.png", fig) ; GLMakie.activate!()
