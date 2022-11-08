using Pkg
Pkg.activate(".")
using GLMakie, CairoMakie 
using Printf, GPCC, JLD2


function runme_produceposteriorplots()

    GLMakie.activate!()

    datasets = ["3C120", "Mrk335", "Mrk6", "Mrk1501", "PG2130099"]


    for d in datasets

        fig = Figure(fontsize = 44, resolution = (2000, 1000))

        ax = Axis(fig[1,1], xlabel = "τ (Days)", ylabel = "Flux", title = d)
        
        # load results stored in file

        filenameresult = "loglikel_"*d*".jld2"

        @printf("Rading file with results %s\n", filenameresult)

        loglikel, candidatedelays  = JLD2.load(filenameresult, "loglikel", "candidatedelays")
        
        posterior = getprobabilities(loglikel)

        @show typeof(candidatedelays) typeof(posterior)

        GLMakie.lines!(ax, candidatedelays, posterior, linewidth=6, color="black")
    
        filenamefig = "posterior_"*d*".png"

        @printf("Saving figure in file %s\n", filenamefig)

        CairoMakie.activate!() ; save(filenamefig, fig) ; GLMakie.activate!()

    end

end

runme_produceposteriorplots()