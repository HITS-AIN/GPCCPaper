
function getposteriordelay_pmf(source)

    # load original posterior delay distribution (expressed in days) 
    filename = @sprintf("posterior_unif_%s.csv", source)
    
    @printf("loading posterior pmf from file %s\n", filename)

    filecontents = readdlm(filename)

    τ, prob = filecontents[:,1], filecontents[:,2]

end

