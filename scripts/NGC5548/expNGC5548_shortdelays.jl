@everywhere using GPCC
using JLD2
using ProgressMeter, Suppressor, Printf
using GPCCData

function runme(source; maxiter=1, numberofrestarts=1, rhomax = rhomax, kernel = kernel, delays = delays)

    tobs, yobs, σobs, = readdataset(source = source);



    @printf("Trying out %d delay combinations in parallel with kernel %s\n", length(delays), string(kernel))

    @showprogress pmap(d->(@suppress performcv(tobs, yobs, σobs; rhomax=rhomax, iterations = maxiter, numberofrestarts = numberofrestarts, delays = [0;collect(d)], kernel = kernel)), delays)

end


# warmup
runme("NGC5548"; maxiter=1, numberofrestarts=1, rhomax = 10, kernel = GPCC.OU, delays = LinRange(0.0, 10, 2*nworkers()))
runme("NGC5548"; maxiter=1, numberofrestarts=1, rhomax = 10, kernel = GPCC.OU, delays = LinRange(0.0, 10, 2*nworkers()))


function properrun(; kernel, rhomax = 700.0, Δt = 0.1, numberofrestarts = 13, name = "shortdelays")

    for source in ["NGC5548"]

        delays = τ = 0.0:Δt:τmax

        cvresults = runme(source, maxiter = 3000, numberofrestarts = numberofrestarts, rhomax = rhomax, kernel = kernel, delays = delays)

        JLD2.save("results_" * name * "_" * source *
                  "_rho_" * string(rhomax) *
                  "_K_"   * string(kernel) *
                  "_Dt_"  * string(Δt)     *
                  "_R_"   * string(numberofrestarts) * ".jld2", "cvresults", cvresults, "delays", collect(delays))

    end

end
