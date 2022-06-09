@everywhere using GPCC
using JLD2
using ProgressMeter, Suppressor, Printf
using GPCCData


function get_indices_for_con_and_hb(f)

    indexcon = occursin.("con", f)

    indexhb = occursin.("hb", f)

    return [findall(indexcon); findall(indexhb)]

end


function runme(source; maxiter=1, numberofrestarts=1, rhomax = rhomax, kernel = kernel, delays = delays)

    tobs, yobs, σobs, files, _minimumtime_ = readdataset(source = source);

    indices = get_indices_for_con_and_hb(files)

    @printf("Using only files\n")
    for i in indices
        display(files[i])
    end

    # use subset of data that correspond to continuum and hb
    tobs = tobs[indices]
    yobs = yobs[indices]
    σobs = σobs[indices]

    @printf("Trying out %d delay combinations in parallel with kernel %s\n", length(delays), string(kernel))

    @showprogress pmap(d->(@suppress performcv(tobs, yobs, σobs; rhomax=rhomax, iterations = maxiter, numberofrestarts = numberofrestarts, delays = [0;collect(d)], kernel = kernel)), delays)

end


# warmup
runme("pg0026"; rhomax=200, maxiter=1, numberofrestarts=1, kernel=GPCC.OU, delays=LinRange(0, 100, 2*nworkers()))
runme("pg0026"; rhomax=200, maxiter=1, numberofrestarts=1, kernel=GPCC.OU, delays=LinRange(0, 100, 2*nworkers()))


function properrun(; kernel, rhomax = 300.0, Δt = 0.1, numberofrestarts = 13, name = "")

    for source in ["pg0804", "pg0844"] #listpgdatasets()

        # Skip datasets that do not contain hb
        if sum(get_indices_for_con_and_hb(readdataset(source = source)[4])) < 2

            continue

        end

        delays = -800.0:Δt:1200.0

        cvresults = runme(source, kernel = kernel, maxiter = 3000, numberofrestarts = numberofrestarts, delays = delays, rhomax = rhomax)

        JLD2.save("results_" * name * "_" * source *
                  "_rho_" * string(rhomax) *
                  "_K_"   * string(kernel) *
                  "_Dt_"  * string(Δt)     *
                  "_R_"   * string(numberofrestarts) * ".jld2", "cvresults", cvresults, "delays", collect(delays))

    end

end
