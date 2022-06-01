@everywhere using GPCC
using JLD2
using ProgressMeter, Suppressor, Printf
using GPCCData


function get_indices_for_con_and_hb(f)

    indexcon = occursin.("con", f)

    indexhb = occursin.("hb", f)

    return [findall(indexcon); findall(indexhb)]

end


function runme(source; maxiter=1, numberofrestarts=1, delays = delays)

    tobs, yobs, σobs, files = readdataset(source = source);

    indices = get_indices_for_con_and_hb(files)

    # use subset of data that correspond to continuum and hb
    tobs = tobs[indices]
    yobs = yobs[indices]
    σobs = σobs[indices]

    @printf("Trying out %d delay combinations in parallel\n", length(delays))

    @showprogress pmap(d->(@suppress performcv(tobs, yobs, σobs; iterations = maxiter, numberofrestarts = numberofrestarts, delays = [0;collect(d)], kernel = GPCC.matern32)), delays)

end


# warmup
runme("pg0026"; maxiter=1, numberofrestarts=1, delays=LinRange(0,100, 2*nworkers()))
runme("pg0026"; maxiter=1, numberofrestarts=1, delays=LinRange(0,100, 2*nworkers()))


function properrun()

    for source in ["pg0804", "pg0844"]

        # Skip datasets that do not contain hb
        if sum(get_indices_for_con_and_hb(readdataset(source = source)[4])) < 2

            continue

        end

        local RESULTS = runme(source, maxiter = 3000, numberofrestarts = 5, delays = -800:0.05:1200.0)

        JLD2.save("results_"*source*".jld2", "results", RESULTS)

    end

end