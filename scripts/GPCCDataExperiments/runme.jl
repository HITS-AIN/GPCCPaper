# Start julia with "julia -O3 -p16" where 16 means 16 parallel workers.
# Alternatively, use the two lines below to start within julia multiple parallel workers.
# using Distributed
# addprocs(16)

@everywhere begin
    using Pkg
    Pkg.activate(".")
    using GPCC
    using ProgressMeter, Suppressor
end

using Printf
using JLD2


function getlikelihoods(datasetname; WARMUP = WARMUP)

    tobs, yobs, σobs,  = readdataset(source = datasetname)

    candidatedelays = collect(0.0:0.2:140)


    if WARMUP

        @printf("\nWARMUP\n")

        @showprogress pmap(candidatedelays[1:2*nworkers()]) do delay

            @suppress gpcc(tobs, yobs, σobs; kernel = GPCC.OU, iterations=3,rhomin=0.01, rhomax = 20, delays = [0; delay], numberofrestarts=1)[1]
            
        end

        return candidatedelays, zeros(length(candidatedelays))

    end


    loglikel = @showprogress pmap(candidatedelays) do delay

        @suppress gpcc(tobs, yobs, σobs; kernel = GPCC.OU, iterations = 2000, rhomin=0.01, rhomax = 2000, delays = [0; delay], numberofrestarts = 7, seed = 1)[1]
        
    end

    return candidatedelays, loglikel

end


function runalldatasets()

    datasets = ["3C120", "Mrk335", "Mrk6", "Mrk1501", "PG2130099"]

    for d in datasets

        filename = @sprintf("loglikel_%s.jld2", d)

        @printf("\nGetting log-likelihoods for datasets %s\n", d)

        @printf("\tStore result in file called %s\n\n", filename)
        
        candidatedelays, loglikel = getlikelihoods(d; WARMUP = false)

        JLD2.save(filename, "candidatedelays", candidatedelays, "loglikel",  loglikel,  "d", d)

    end

end

# Do warmup
getlikelihoods("3C120"; WARMUP = true)
getlikelihoods("3C120"; WARMUP = true)

# Calculate log-likelihoods and store them in JLD2 files
runalldatasets()


