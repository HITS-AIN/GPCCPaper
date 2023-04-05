using Pkg
Pkg.activate(".")
Pkg.instantiate()

using DelimitedFiles, Distributions, GLMakie, CairoMakie, Printf

include("getposteriordelay_pmf.jl")


function samplemass(src; numsamples = 2_000_000, fixdelaytomean = fixdelaytomean, σvdensity = σvdensity)

    delays, prob = getposteriordelay_pmf(src)

    # HACK: it is as if we are fixing the value of the delay to its mean value
    if fixdelaytomean 
        delays .= sum(delays.*prob)
    end

    pdelay = Categorical(prob)


    # physical quantities

    f = 5.5

    c = 2.99792458e8 # speed of light in m s-1

    G = 6.67259e-11  # Gravitational constant in m3 kg-1 s-2
 
    msun = 1.9891e30
    
    day2secs = 24 * 3600


    samples = zeros(numsamples)

    for i in 1:numsamples

        σv  = rand(σvdensity)

        τ = delays[rand(pdelay)] * day2secs
 
        samples[i] =  f * c * τ * σv^2 / G  # (see equation under Data applications, Mass estimation for 3C120)

    end
   
    return samples / msun # convert to solar masses

end



function runme(; source = source, σvdensity = σvdensity, reported_density = reported_density)

    @printf("\nWorking on source %s\n", source)

    GLMakie.activate!()
 
    
    for fixdelaytomean in [true, false]

        #----------------#
        #  setup figure  #
        #----------------#

        fig = Figure(fontsize = 36, resolution = (1600, 1000)) 


        #-----------------#
        # produce samples # 
        #-----------------#

        samples = samplemass(source; fixdelaytomean = fixdelaytomean, σvdensity = σvdensity)

        @printf("Mean of black hole mass samples is %e\n", mean(samples))
        @printf("Std of black hole mass samples is %e\n", std(samples))


        #-----------------------------------------------#
        # Create axes and label them, also label figure #
        #-----------------------------------------------#

        title = fixdelaytomean ? @sprintf("Mass distribution for %s with delay fixed to mean", source) :
                                 @sprintf("Mass distribution for %s", source)

        @show highestpower = prevpow(10, minimum(samples)) # try also nextpow if axis doesn't show properly

        function customxtick(values)
            map(values) do v
                "$(v/highestpower)"
            end
        end

        myxticks = round.(collect(LinRange(highestpower, 10*highestpower, 10)))

        powerstr = @sprintf("%d", round(Int, log10(highestpower)))

        ax = Axis(fig[1,1], xlabel = L"M_{BH}(M_\odot)\times 10^%$powerstr", ylabel = "density", title = "", xticks = myxticks, xtickformat = customxtick, yticklabelsize = 26, yticklabelsvisible = true,xgridvisible = false, ygridvisible = false)

        GLMakie.hist!(ax, samples, bins = 250, normalization = :pdf, color = :gray, label="our estimate")

        massrange = minimum(samples):100:maximum(samples)

        GLMakie.lines!(ax, massrange, pdf.(reported_density, massrange), linewidth=6, color="blue", label = "G+2012")

        axislegend(framevisible = false)


        #---------------------#
        # Save figure in file #
        #---------------------#

        filenamefig = fixdelaytomean ? @sprintf("massdistribution%s_fixdelaytomean.png", source) : 
                                       @sprintf("massdistribution%s.png", source)

        @printf("Saving figure in file %s\n", filenamefig)

        CairoMakie.activate!() ; save(filenamefig, fig) ; GLMakie.activate!()


        #--------------------------------------------#
        # Save samples of histogram plot in csv file #
        #--------------------------------------------#

        filenamecsv = fixdelaytomean ? @sprintf("massdistribution%s_fixdelaytomean.csv", source) : 
                                       @sprintf("massdistribution%s.csv", source)

        @printf("Saving samples of histogram in file %s\n", filenamecsv)

        writedlm(filenamecsv, samples)


    end

end

runme(;source = "3C120",   σvdensity = Normal(1514.0 * 1e3, 65 * 1e3),  reported_density = Normal(6.7 * 1e7, 0.6 * 1e7))

runme(;source = "Mrk1501", σvdensity = Normal(3321.0 * 1e3, 107 * 1e3), reported_density = Normal(184 * 1e6, 27 * 1e6))