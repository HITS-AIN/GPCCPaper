@everywhere begin
    using Pkg
    Pkg.activate(".")
    using GPCC
end

using JLD2, Distributions, MiscUtil, LinearAlgebra, ProgressMeter, Suppressor, Printf, Random # may need to be indepedently installed

include("simulatedata.jl")


function runme_joint(;maxiter=1)

    tobs, yobs, σobs = simulatedata(seed=1)

    candidatedelays = -9:0.2:9

    let
        @printf("Trying out %d delay combinations in parallel\n", length(candidatedelays)^2)
        
        loglikel = @showprogress pmap(d2 -> map(d1 -> (@suppress gpcc(tobs, yobs, σobs; kernel = GPCC.matern32, delays = [0;d1;d2], iterations = maxiter, rhomax = 1000)[1]), candidatedelays), candidatedelays);
    

        filename = "results_synthetic_threelightcurves_joint.jld2"

        @printf("Writing results in file %s\n", filename)

        JLD2.save(filename, "loglikel", loglikel, "candidatedelays", collect(candidatedelays), "tobs", tobs, "yobs", yobs, "σobs", σobs)
    end

    let 

        tobs, yobs, σobs = tobs[[2;3;1]], yobs[[2;3;1]], σobs[[2;3;1]]

        @printf("Trying out %d delay combinations in parallel\n", length(candidatedelays)^2)
        
        loglikel = @showprogress pmap(d2 -> map(d1 -> (@suppress gpcc(tobs, yobs, σobs; kernel = GPCC.matern32, delays = [0;d1;d2], iterations = maxiter, rhomax = 1000)[1]), candidatedelays), candidatedelays);
    

        filename = "results_synthetic_threelightcurves_joint_reordered.jld2"

        @printf("Writing results in file %s\n", filename)

        JLD2.save(filename, "loglikel", loglikel, "candidatedelays", collect(candidatedelays), "tobs", tobs, "yobs", yobs, "σobs", σobs)
    end


    # return loglikel, candidatedelays, tobs, yobs, σobs

end


function runme_pairwise(;maxiter=1)

    tobs, yobs, σobs = simulatedata(seed=1)

    candidatedelays = -11:0.15:11

    
    @printf("Trying out %d delay combinations in parallel\n", length(candidatedelays))
    
    loglikel12 = @showprogress pmap(τ -> (@suppress gpcc(tobs[1:2],   yobs[1:2],   σobs[1:2];   iterations = maxiter, rhomax = 300, numberofrestarts = 1, delays = [0;τ], kernel = GPCC.matern32)[1]), candidatedelays)

    loglikel13 = @showprogress pmap(τ -> (@suppress gpcc(tobs[[1;3]], yobs[[1;3]], σobs[[1;3]]; iterations = maxiter, rhomax = 300, numberofrestarts = 1, delays = [0;τ], kernel = GPCC.matern32)[1]), candidatedelays)

    loglikel23 = @showprogress pmap(τ -> (@suppress gpcc(tobs[[2;3]], yobs[[2;3]], σobs[[2;3]]; iterations = maxiter, rhomax = 300, numberofrestarts = 1, delays = [0;τ], kernel = GPCC.matern32)[1]), candidatedelays)


    filename = "results_synthetic_threelightcurves_pairwise.jld2"

    @printf("Writing results in file %s\n", filename)

    JLD2.save(filename, "loglikel12", loglikel12, "loglikel13", loglikel13, "loglikel23", loglikel23,
     "candidatedelays", collect(candidatedelays), "tobs", tobs, "yobs", yobs, "σobs", σobs)


    return loglikel12, loglikel13, loglikel23, candidatedelays, tobs, yobs, σobs

end


# warmup
runme_joint(maxiter=1)
runme_pairwise(maxiter=1)
