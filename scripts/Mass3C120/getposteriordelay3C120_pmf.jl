
function getposteriordelay3C120_pmf()

    # load original posterior delay (expressed in days) distribution for 3C120
    
    filecontents = readdlm("posterior_unif_3C120.csv")

    τ, prob = filecontents[:,1], filecontents[:,2]

end

