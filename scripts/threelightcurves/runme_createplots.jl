using Pkg
Pkg.activate(".")
using GLMakie, CairoMakie 
using Printf, GPCC, JLD2, Distributions, DelimitedFiles


function createplots()

    # setup figure

    GLMakie.activate!()

    f = GLMakie.Figure(resolution = (1800, 1800), fontsize = 44)

    display(f) 

    GL = f[1:2, 1:2] = GridLayout()


    # load results

    candidatedelays, loglikel = JLD2.load("three_lightcurves.jld2", "candidatedelays", "loglikel")


    # setup axes

    @printf("\t Restricting delay axes in interval 0-10\n")
   
    axtop   = Axis(GL[1, 1], title  = "marginal posterior for 9100", xlabel = L"τ_3 (Days)", ylabel = L"\pi_i")
    xlims!(axtop, 0, 10)
    axtop.xticks = 0:2:10
   
    axmain  = Axis(GL[2, 1], xlabel = L"9100, \tau_3", ylabel = L"7700, \tau_2")
    xlims!(axmain, 0, 10)
    ylims!(axmain, 0, 10)
    axmain.yticks = 0:2:10
    axmain.xticks = 0:2:10
   
    axright = Axis(GL[2, 2], title  = "marginal posterior for 7700", ylabel = L"τ_2  (Days)", xlabel = L"\pi_i")
    ylims!(axright, 0, 10)
    axright.xticks = 0:0.05:0.1
    axright.yticks = 0:2:10

    linkyaxes!(axmain, axright)
    linkxaxes!(axmain, axtop)

    
    # calculate posteriors

    posterior = getprobabilities(reduce(vcat, loglikel))

    posterior = reshape(posterior, length(candidatedelays), length(candidatedelays));


    # plot posteriors

    lines!(axtop, candidatedelays,vec(sum(posterior,dims=1)), color =:black, linewidth=4)
    lines!(axright, vec(sum(posterior,dims=2)), candidatedelays, color =:black, linewidth=4)
    contourf!(axmain, candidatedelays, candidatedelays, posterior, colormap=Reverse(:grays))

   
    # save figure in file
    
    filenamefig = "2Dposterior_Mgc0811.png"

    @printf("Saving figure in file %s\n", filenamefig)

    CairoMakie.activate!() ; save(filenamefig, f) ; GLMakie.activate!()


    # Save values of joint posterior in file

    filenamejoint = "joint_posterior_Mgc0811.csv"

    @printf("Saving values of joint posterior in file %s\n", filenamejoint)

    writedlm(filenamejoint, posterior)


    # Save values of marginal 7700 in file

    filenamemarginal7700 = "marginal_posterior_7700_Mgc0811.csv"

    @printf("Saving values of marginal posterior 7700 in file %s\n", filenamemarginal7700)

    writedlm(filenamemarginal7700, vec(sum(posterior,dims=2)))


    # Save values of marginal 9100 in file

    filenamemarginal9100 = "marginal_posterior_9100_Mgc0811.csv"

    @printf("Saving values of marginal posterior 9100 in file %s\n", filenamemarginal9100)

    writedlm(filenamemarginal9100, vec(sum(posterior,dims=1)))


    # Save values of candidate delays in file

    filenamedelays = "candidatedelays_Mgc0811.csv"

    @printf("Saving values of candidate delays in file %s\n", filenamedelays)

    writedlm(filenamedelays, candidatedelays)


    nothing
end

createplots()