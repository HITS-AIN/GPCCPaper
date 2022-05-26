@everywhere using GPCC
using JLD2
using ProgressMeter, Suppressor, Printf
using GPCCData

function formdelays(source)

    tobs, = readdataset(source = source);

    τmax = maximum(maximum.(tobs)) - minimum(minimum.(tobs))

    τ = 0.0:0.2:1.0*τmax

    L = length(tobs)

    delays = Iterators.product([τ for l in 1:L-1]...)

    return delays

end

function runme(source; maxiter=1, numberofrestarts=1)

    tobs, yobs, σobs = readdataset(source = source);

    delays = formdelays(source)

    @printf("Trying out %d delay combinations in parallel\n", length(delays))

    @showprogress pmap(d->(@suppress performcv(tobs, yobs, σobs; iterations = maxiter, numberofrestarts = numberofrestarts, delays = [0;collect(d)], kernel = GPCC.matern32)), delays)

end


# warmup
runme("3C120"; maxiter=1, numberofrestarts=1)
runme("3C120"; maxiter=1, numberofrestarts=1)


function properrun()

    for source in ["pg2130"]

        local RESULTS = runme(source, maxiter = 2000, numberofrestarts = 10)

        JLD2.save("results_"*source*".jld2", "results", RESULTS)

    end

end
