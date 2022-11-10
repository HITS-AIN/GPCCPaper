using Pkg
Pkg.activate(".")
using GLMakie, CairoMakie 
using Printf, GPCC, JLD2, Distributions


function createplots()

    GLMakie.activate!()

    f = GLMakie.Figure(resolution = (1800, 1800), fontsize = 44)

    display(f) 

    GL = f[1:2, 1:2] = GridLayout()

    candidatedelays, loglikel = JLD2.load("three_lightcurves.jld2", "candidatedelays", "loglikel")

    @printf("\t Restricting delay axes in interval 0-10\n")
   
    axtop   = Axis(GL[1, 1], title  = "marginal posterior for 9100", xlabel = "τ (Days)", ylabel = L"\pi_i")
    xlims!(axtop, 0, 10)
   
    axmain  = Axis(GL[2, 1], xlabel = "9100", ylabel = "7700")
    xlims!(axmain, 0, 10)
    ylims!(axmain, 0, 10)
   
    axright = Axis(GL[2, 2], title  = "marginal posterior for 7700", ylabel = "τ (Days)", xlabel = L"\pi_i")
    ylims!(axright, 0, 10)
    axright.xticks = 0:0.05:0.1

    linkyaxes!(axmain, axright)
    linkxaxes!(axmain, axtop)

    posterior = getprobabilities(reduce(vcat, loglikel))

    posterior = reshape(posterior, length(candidatedelays), length(candidatedelays));

    lines!(axtop, candidatedelays,vec(sum(posterior,dims=1)), color =:black, linewidth=4)
    lines!(axright, vec(sum(posterior,dims=2)), candidatedelays, color =:black, linewidth=4)
    contourf!(axmain, candidatedelays, candidatedelays, posterior, colormap=Reverse(:grays))

    filenamefig = "2Dposterior_Mgc0811.png"

    @printf("Saving figure in file %s\n", filenamefig)

    CairoMakie.activate!() ; save(filenamefig, f) ; GLMakie.activate!()

    return f
end

createplots()