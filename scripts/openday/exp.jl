@everywhere using GPCC
using JLD2
using ProgressMeter, Suppressor, Printf
using DelimitedFiles

function readopendaydata()

    xblue, yblue, σblue = readdlm("B.dat")[:,1], readdlm("B.dat")[:,2], readdlm("B.dat")[:,3]

    xred, yred, σred = readdlm("Halpha.dat")[:,1], readdlm("Halpha.dat")[:,2], readdlm("Halpha.dat")[:,3]

    [xblue, xred], [yblue, yred], [σblue, σred]

end


function formdelays(Δt)

    tobs, = readopendaydata()

    τmax = maximum(maximum.(tobs)) - minimum(minimum.(tobs))

    τ = 0.0:Δt:τmax

    L = length(tobs)

    delays = Iterators.product([τ for l in 1:L-1]...)

    return delays

end

function runme(;maxiter=1, numberofrestarts=1, rhomax = rhomax, kernel = kernel, delays = delays)

    tobs, yobs, σobs = readopendaydata()


    @printf("Trying out %d delay combinations in parallel with kernel %s\n", length(delays), string(kernel))

    @showprogress pmap(d->(@suppress performcv(tobs, yobs, σobs; rhomax=rhomax, iterations = maxiter, numberofrestarts = numberofrestarts, delays = [0;collect(d)], kernel = kernel)), delays)

end


# warmup
runme(; maxiter=1, numberofrestarts=1, rhomax = 10, kernel = GPCC.OU, delays = LinRange(0.0, 10, 2*nworkers()))
runme(; maxiter=1, numberofrestarts=1, rhomax = 10, kernel = GPCC.OU, delays = LinRange(0.0, 10, 2*nworkers()))


function properrun(; kernel, rhomax = 500.0, Δt = 0.1, numberofrestarts = 13, name = "")

        delays = formdelays(Δt)

        cvresults = runme(maxiter = 3000, numberofrestarts = numberofrestarts, rhomax = rhomax, kernel = kernel, delays = delays)

        JLD2.save("results_" * name * "_" * "openday" *
                  "_rho_" * string(rhomax) *
                  "_K_"   * string(kernel) *
                  "_Dt_"  * string(Δt)     *
                  "_R_"   * string(numberofrestarts) * ".jld2", "cvresults", cvresults, "delays", collect(delays))

end
