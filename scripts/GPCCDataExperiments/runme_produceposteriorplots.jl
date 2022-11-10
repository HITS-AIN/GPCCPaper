using Pkg
Pkg.activate(".")
using GLMakie, CairoMakie 
using Printf, GPCC, JLD2, Distributions, DelimitedFiles


function runme_produceposteriorplots()

    GLMakie.activate!()

    datasets = ["3C120", "Mrk335", "Mrk6", "Mrk1501", "PG2130099"]

    
    prior = Dict("3C120"    => uniformpriordelay(L = 9.12e43, z = 0.0330),
                "Mrk335"    => uniformpriordelay(L = 5.01e43, z = 0.0258),
                "Mrk6"      => uniformpriordelay(L = 5.62e43, z = 0.0188),
                "Mrk1501"   => uniformpriordelay(L = 2.09e44, z = 0.0893),
                "PG2130099" => uniformpriordelay(L = 1.41e44, z = 0.0630))

                	
    for d in datasets


        # Load results stored in file

        filenameresult = "loglikel_"*d*".jld2"

        @printf("Reading file %s\n", filenameresult)

        loglikel, candidatedelays  = JLD2.load(filenameresult, "loglikel", "candidatedelays")
        

        # Calculate posteriors using respectively the uniform prior and the flat prior

        local posterior_unif = getprobabilities(loglikel, logpdf.(prior[d], candidatedelays))

        local posterior_flat = getprobabilities(loglikel)


        # Plot posteriors

        for (post, label, name) in zip([posterior_unif, posterior_flat], 
                                       [L"p(\tau)=U(0,\tau_{\text{max}}(l,z))", L"p(\tau)\propto 1"],
                                       ["unif", "flat"])


            # The line below controls the size of the figure via the resolution argument

            fig = Figure(fontsize = 44, resolution = (2000, 1000)) 


            # Create axes and label them, also label figure

            ax = Axis(fig[1,1], xlabel = "τ (Days)", ylabel = L"\mathbf{\pi}_i", title = d)
            
            GLMakie.lines!(ax, candidatedelays, post, linewidth=6, color="black", label = label)
        
            axislegend(framevisible = false)

            ax.xticks = 0:10:140


            # Save figure in file

            filenamefig = "posterior_" * name * "_" *d* ".png"

            @printf("Saving figure in file %s\n", filenamefig)

            CairoMakie.activate!() ; save(filenamefig, fig) ; GLMakie.activate!()


            # Save values in plot in csv file

            filenamecsv = "posterior_" * name * "_" *d* ".csv"

            @printf("Saving values in file %s\n", filenamecsv)

            writedlm(filenamecsv, [candidatedelays post])

        end

 
    end

end

runme_produceposteriorplots()