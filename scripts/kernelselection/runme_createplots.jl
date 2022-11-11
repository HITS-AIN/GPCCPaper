using Pkg
Pkg.activate(".")
using GLMakie, CairoMakie # ❗ important that Makie is imported first 
using GPCC, Printf, JLD2
using Statistics



function createplots()

    #----------------------------#
    # Load data from experiments #
    #----------------------------#

    # The first two regard 3C120

    R1 = JLD2.load("experiment1.jld2") # kernel was GPCC.OU

    R2 = JLD2.load("experiment2.jld2") # kernel was GPCC.matern32

    # These two regard Mrk6

    R3 = JLD2.load("experiment3.jld2") # kernel was GPCC.OU

    R4 = JLD2.load("experiment4.jld2") # kernel was GPCC.matern32


    #---------------------------------#
    #    Create figures for 3C120     #
    #---------------------------------#

    # Setup figure

    GLMakie.activate!()

    fig = GLMakie.Figure(resolution = (1300, 1300), fontsize = 44)
   
    ax1 = Axis(fig[1,1], xlabel = "Days", ylabel = "log-likelihood")


    # plot data

    GLMakie.lines!(ax1, vec(R1["candidatedelays"]), mean.(R1["results"]), linewidth=4, color="red", label="OU")
    
    GLMakie.lines!(ax1, vec(R2["candidatedelays"]), mean.(R2["results"]), linewidth=4, color="blue", label="Matern32")
 

    # take care of axis and legend

    ax1.xticks = 0:20:140

    xlims!(ax1, -1, 145)

    axislegend(position=:rb)


    # save figure in file
    
    filename = "CV_3C120_OU_vs_matern.png"
    
    @printf("\nSaving plot in file %s\n", filename)

    CairoMakie.activate!() ; save(filename, fig) ; GLMakie.activate!()


    # output statistics to terminal

    @printf("\nStatistics for 3C120 (higher is better)\n")
    @printf("\t       OU: mean cv = %.3f\n", mean(mean.(R1["results"])))
    @printf("\t Matern32: mean cv = %.3f\n", mean(mean.(R2["results"])))


    #---------------------------------#
    #    Create figures for Mrk6      #
    #---------------------------------#

    # Setup figure

    GLMakie.activate!()

    fig = GLMakie.Figure(resolution = (1300, 1300), fontsize = 44)
   
    ax1 = Axis(fig[1,1], xlabel = "Days", ylabel = "log-likelihood")


    # plot data

    GLMakie.lines!(ax1, vec(R3["candidatedelays"]), mean.(R3["results"]), linewidth=4, color="red", label="OU")
    
    GLMakie.lines!(ax1, vec(R4["candidatedelays"]), mean.(R4["results"]), linewidth=4, color="blue", label="Matern32")
 

    # take care of axis and legend

    ax1.xticks = 0:20:140

    xlims!(ax1, -1, 145)

    axislegend(position=:rb)


    # save figure in file

    filename = "CV_Mrk6_OU_vs_matern.png"

    @printf("\nSaving plot in file %s\n", filename)

    CairoMakie.activate!() ; save(filename, fig) ; GLMakie.activate!()

     # output statistics to terminal

     @printf("\nStatistics for Mrk6 (higher is better)\n")
     @printf("\t      OU: mean cv = %.3f\n", mean(mean.(R3["results"])))
     @printf("\tMatern32: mean cv = %.3f\n", mean(mean.(R4["results"])))

end


createplots()