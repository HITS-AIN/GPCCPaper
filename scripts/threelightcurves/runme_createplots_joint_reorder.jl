using Pkg
Pkg.activate(".")
using GLMakie, CairoMakie 
using Printf, GPCC, JLD2, Distributions, DelimitedFiles


function createplots_joint_reorder()

    #--------------#
    # setup figure #
    #--------------#

    GLMakie.activate!()

    f = GLMakie.Figure(resolution = (1900, 1900), fontsize = 44)

    display(f) 

    GL = f[1:2, 1:2] = GridLayout()


    #--------------#
    # load results #
    #--------------#

    candidatedelays, loglikel = JLD2.load("three_lightcurves_joint_312.jld2", "candidatedelays", "loglikel")

    candidatedelays = candidatedelays*-1

    #------------#
    # setup axes #
    #------------#

    @printf("\t Restricting delay axes in interval 0-10\n")
   
    axtop   = Axis(GL[1, 1], title  = L"\textrm{marginal delay between 7700}\AA \textrm{ and 9100}\AA",  xlabel = "delays (days)", ylabel = L"\pi_i")
    xlims!(axtop, 0,10)
    axtop.xticks = 0:2:10
   
    axmain  = Axis(GL[2, 1], title = "joint posterior", xlabel = L"\textrm{delay between 7700}\AA \textrm{ and 9100}\AA", ylabel = L"\textrm{delay between 5100}\AA\textrm{ and 9100}\AA")
    xlims!(axmain, 0,10)
    ylims!(axmain, 0,10)
    axmain.yticks = 0:2:10
    axmain.xticks = 0:2:10
   
    axright = Axis(GL[2, 2], title  = L"\textrm{marginal delay between 5100}\AA\textrm{ and 9100}\AA", ylabel = "delays (days)", xlabel = L"\pi_i")
    ylims!(axright, 0,10)
    axright.xticks = 0:0.05:0.1
    axright.yticks = 0:2:10

    linkyaxes!(axmain, axright)
    linkxaxes!(axmain, axtop)


    #----------------------#
    # calculate posteriors #
    #----------------------#

    posterior = getprobabilities(reduce(vcat, loglikel))

    posterior = reshape(posterior, length(candidatedelays), length(candidatedelays));


    #-------------------------------#
    # plot posteriors               #
    #-------------------------------#
    # 1st light curve is at 9100 Å
    # 2nd light curve is at 5100 Å
    # 3rd light curve is at 7700 Å
    #-------------------------------#

    # to get posterior for delay between 1st and 2nd light curve use sum(posterior,dims=2)
    posterior12 = vec(sum(posterior,dims=2))

    # to get posterior for delay between 1st and 3rd light curve use sum(posterior,dims=1)
    posterior13 = vec(sum(posterior,dims=1))

    lines!(axtop, candidatedelays,posterior13, color =:black, linewidth=4)
    lines!(axright, posterior12, candidatedelays, color =:blue, linewidth=4)
    contourf!(axmain, candidatedelays, candidatedelays, posterior, colormap=Reverse(:grays))


    #-----------------#
    # print out means #
    #-----------------#

    @printf("Mean delay between 1st and 2nd light curve is \t %.3f\n", sum(posterior12 .* candidatedelays))

    @printf("Mean delay between 1st and 3rd light curve is \t %.3f\n", sum(posterior13 .* candidatedelays))



    #---------------------#
    # save figure in file #
    #---------------------#

    filenamefig = "2Dposterior_Mgc0811_reorder.png"

    @printf("Saving figure in file %s\n", filenamefig)

    CairoMakie.activate!() ; save(filenamefig, f) ; GLMakie.activate!()


    # # Save values of joint posterior in file

    # filenamejoint = "joint_posterior_Mgc0811.csv"

    # @printf("Saving values of joint posterior in file %s\n", filenamejoint)

    # writedlm(filenamejoint, posterior)


    # # Save values of marginal 7700 in file

    # filenamemarginal7700 = "marginal_posterior_7700_Mgc0811.csv"

    # @printf("Saving values of marginal posterior 7700 in file %s\n", filenamemarginal7700)

    # writedlm(filenamemarginal7700, posterior12)


    # # Save values of marginal 9100 in file

    # filenamemarginal9100 = "marginal_posterior_9100_Mgc0811.csv"

    # @printf("Saving values of marginal posterior 9100 in file %s\n", filenamemarginal9100)

    # writedlm(filenamemarginal9100, posterior13)


    # # Save values of candidate delays in file

    # filenamedelays = "candidatedelays_Mgc0811.csv"

    # @printf("Saving values of candidate delays in file %s\n", filenamedelays)

    # writedlm(filenamedelays, candidatedelays)


    nothing
end

createplots_joint_reorder()