@everywhere using GPCC
using JLD2
using ProgressMeter, Suppressor, Printf
using ADDatasets
using Dates

function formdelays(tobs, Δt)

    τmax = maximum(maximum.(tobs)) - minimum(minimum.(tobs))

    τ = 0.0:Δt:τmax

    L = length(tobs)

    delays = Iterators.product([τ for l in 1:L-1]...)

    return delays

end


function determinerhomax(source, kernel)

    _, tobs, yobs, σobs, = readdataset(source = source)

    rho_array = map(1:length(tobs)) do index

        params = GPCC.singlegp(tobs[index], yobs[index], σobs[index]; kernel=kernel, iterations=3000, seed=1, numberofrestarts=100, initialrandom=5, rhomax = 5000)[3]

        params[3]

    end

    @printf("Returned rho when fitting single lightcurves\n")

    map(x->@printf("%f\n",x), rho_array)

    rhomax = maximum(rho_array) * 1.30

    @printf("Returning rhomax = %f\n", rhomax)

    return rhomax

end


function runme(tobs, yobs, σobs; maxiter=1, numberofrestarts=1, rhomax = rhomax, kernel = kernel, delays = delays)

    @printf("Trying out %d delay combinations in parallel with kernel %s\n", length(delays), string(kernel))

    @showprogress pmap(d->(@suppress performcv(tobs, yobs, σobs; rhomax=rhomax, iterations = maxiter, numberofrestarts = numberofrestarts, delays = [0;collect(d)], kernel = kernel)), delays)

end


function properrun(; kernel, Δt = 0.05, numberofrestarts = 13, name = "")

        source = "Mgc0811"

        rhomax = determinerhomax(source, kernel)

        lambda, tobs, yobs, σobs, = readdataset(source = source);

        for i in 1:5

            delays = formdelays(tobs[[i;6]], Δt)

            @printf("Running GPCC between %f and %f\n", lambda[i], lambda[6])

            cvresults = runme(tobs[[i;6]], yobs[[i;6]], σobs[[i;6]], maxiter = 3000, numberofrestarts = numberofrestarts, rhomax = rhomax, kernel = kernel, delays = delays)

            JLD2.save("results_" * name * "_Mgc0811_" * string(lambda[i]) * "_" * string(lambda[6]) * 
                        "_date_" * string(today()) *
                        "_rho_" * string(rhomax)  *
                        "_K_"   * string(kernel)  *
                        "_Dt_"  * string(Δt)      *
                        "_R_"   * string(numberofrestarts) * ".jld2", "cvresults", cvresults, "delays", collect(delays))

    end

end



# warmup
let 
    _lambda, tobs, yobs, σobs = readdataset(source = "Mgc0811")

    runme(tobs[[1;2]], yobs[[1;2]], σobs[[1;2]]; maxiter=1, numberofrestarts=1, rhomax = 10.0, kernel = GPCC.OU, delays = LinRange(0.0, 10, 2*nworkers()))

    runme(tobs[[1;2]], yobs[[1;2]], σobs[[1;2]]; maxiter=1, numberofrestarts=1, rhomax = 10.0, kernel = GPCC.OU, delays = LinRange(0.0, 10, 2*nworkers()))

end