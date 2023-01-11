using Pkg
Pkg.activate(".")
Pkg.instantiate()

using DelimitedFiles, Distributions, Interpolations, MiscUtil


function mass3C120pmf()

    pdelays = getposteriordelay3C120_inseconds()


    # physical quantities

    f = 5.5

    c = 2.99792458e8 # speed of light in m s-1

    G = 6.67259e-11  # Gravitational constant in m3 kg-1 s-2
 
    msun = 1.9891e30
    
    # σvdensity = Normal(1514.0 * 1e3, 65 * 1e3)
    
    σv²density = squarednormal(; μ = 1514.0 * 1e3, σ = 65 * 1e3)
    
    day2secs = 24 * 3600

    delayrange = (1e-6*day2secs):0.2*day2secs:(140*day2secs) # specific for object 3C120

    
    figure()

    plot(delayrange, pdelays.(delayrange))

    title("delay posterior in seconds")

    @show verify_getposteriordelay3C120_inseconds()

    
    massrange  = logrange(1e6, 1e8, 1_000)
    
    masspmf    = zeros(length(massrange))

    
    for (massindex, mass) in enumerate(massrange)
        
        for delay in delayrange

            velocity = (mass/msun)/delay
            
            masspmf[massindex] += (1/abs(delay)) * pdelays(delay) * σv²density(velocity)
            
            
        end

        
    end

    return massrange, masspmf/sum(masspmf)

end


function getposteriordelay3C120_inseconds()

    pdays = getposteriordelay3C120_pdf()

    g(y) = y / (24 * 3600)

    pseconds(y) = pdays(g(y)) * (1/ (24 * 3600))

end


function verify_getposteriordelay3C120_inseconds()

    psecs = getposteriordelay3C120_inseconds()

    hquadrature(psecs, 0, 140 * 24 * 3600)

end