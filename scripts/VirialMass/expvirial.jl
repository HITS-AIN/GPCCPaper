@everywhere using GPCC
using JLD2
using ProgressMeter, Suppressor, Printf
using GPCCData
using Dates

function formdelays(source, Δt)

    tobs, = readdataset(source = source);

    τmax = maximum(maximum.(tobs)) - minimum(minimum.(tobs))

    τ = 0.0:Δt:τmax

    L = length(tobs)

    delays = Iterators.product([τ for l in 1:L-1]...)

    return delays

end


function determinerhomax(source, kernel)

    tobs, yobs, σobs, = readdataset(source = source)

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


function runme(source; maxiter=1, numberofrestarts=1, rhomax = rhomax, kernel = kernel, delays = delays)

    tobs, yobs, σobs, = readdataset(source = source);

    @printf("Trying out %d delay combinations in parallel with kernel %s\n", length(delays), string(kernel))

    @showprogress pmap(d->(@suppress performcv(tobs, yobs, σobs; rhomax=rhomax, iterations = maxiter, numberofrestarts = numberofrestarts, delays = [0;collect(d)], kernel = kernel)), delays)

end


function properrun(; kernel, Δt = 0.025, numberofrestarts = 13, name = "")

    for source in listvirialdatasets()

        delays = formdelays(source, Δt)

        rhomax = determinerhomax(source, kernel)

        cvresults = runme(source, maxiter = 3000, numberofrestarts = numberofrestarts, rhomax = rhomax, kernel = kernel, delays = delays)

        JLD2.save("results_" * name * "_" * source *
		         "_date_" * string(today()) *
                  "_rho_" * string(rhomax) *
                  "_K_"   * string(kernel) *
                  "_Dt_"  * string(Δt)     *
                  "_R_"   * string(numberofrestarts) * ".jld2", "cvresults", cvresults, "delays", collect(delays))

    end

end



# warmup
runme("3C120"; maxiter=1, numberofrestarts=1, kernel = GPCC.OU, delays = LinRange(0.0, 10, 2*nworkers()))
runme("3C120"; maxiter=1, numberofrestarts=1, kernel = GPCC.OU, delays = LinRange(0.0, 10, 2*nworkers()))