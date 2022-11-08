@everywhere begin
    using Pkg
    Pkg.activate(".")
    using GPCC
end

using JLD2
using ProgressMeter, Suppressor, Printf
using DelimitedFiles


function readopendaydata()

    xblue, yblue, σblue = readdlm("B.dat")[:,1], readdlm("B.dat")[:,2], readdlm("B.dat")[:,3]

    xred,  yred,  σred  = readdlm("Halpha.dat")[:,1], readdlm("Halpha.dat")[:,2], readdlm("Halpha.dat")[:,3]

    [xblue, xred], [yblue, yred], [σblue, σred]

end


function runexperiment(;maxiter=1, numberofrestarts=1, rhomax = rhomax, kernel = kernel, delays = delays)

    tobs, yobs, σobs = readopendaydata()

    @printf("Trying out %d delay combinations in parallel with kernel %s\n", length(delays), string(kernel))

    @showprogress pmap(d->(@suppress gpcc(tobs, yobs, σobs; rhomax=rhomax, iterations = maxiter, numberofrestarts = numberofrestarts, delays = [0;collect(d)], kernel = kernel)[1]), delays)

end


function properrun(; kernel = GPCC.OU, rhomax = 2000.0, Δt = 0.1, numberofrestarts = 5, name = "_")

        delays = 0.0:Δt:200

        loglikel = runexperiment(maxiter = 3000, numberofrestarts = numberofrestarts, rhomax = rhomax, kernel = kernel, delays = delays)

        filename = "results_" * name * 
                      "_rho_" * string(rhomax) *
                      "_K_"   * string(kernel) *
                      "_Dt_"  * string(Δt)     *
                      "_R_"   * string(numberofrestarts) * ".jld2"

        @printf("Saving results in file %s\n", filename)

        JLD2.save(filename, "loglikel", loglikel, "delays", collect(delays))

        return delays, loglikel
        
end


@printf("Doing warmup\n")
# warmup
runexperiment(; maxiter=1, numberofrestarts=1, rhomax = 10, kernel = GPCC.OU, delays = LinRange(0.0, 10, 2*nworkers()))
runexperiment(; maxiter=1, numberofrestarts=1, rhomax = 10, kernel = GPCC.OU, delays = LinRange(0.0, 10, 2*nworkers()))

@printf("Run numerical experiment\n")

delays, loglikel = properrun()