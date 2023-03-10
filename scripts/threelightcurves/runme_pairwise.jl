@everywhere begin
    using Pkg
    Pkg.activate(".")
    using GPCC # make sure GPCC is made available to all workers
    using ProgressMeter, Suppressor # need to be independently installed
end


using GPCCData, Printf, JLD2


function run_threelightcurves_pairwise(; candidatedelays = collect(0.0:0.01:10), iterations = 2000)

    lambda, tobs, yobs, σobs = let

        tobs, yobs, σobs, lambda, = readdataset(source = "Mgc0811")

        # select indices that correspond to 5100, 7700 and 9100.0

        idx = [6, 4, 5]

        @printf("Using the following wavelengths:\n"); display(lambda[idx])

        lambda[idx], tobs[idx], yobs[idx], σobs[idx]

    end


    let

        loglikel12 = @showprogress pmap(d -> (@suppress gpcc(tobs[[1;2]], yobs[[1;2]], σobs[[1;2]]; kernel = GPCC.matern32, delays = [0;d], iterations = iterations, rhomax = 2000)[1]), candidatedelays)
        loglikel13 = @showprogress pmap(d -> (@suppress gpcc(tobs[[1;3]], yobs[[1;3]], σobs[[1;3]]; kernel = GPCC.matern32, delays = [0;d], iterations = iterations, rhomax = 2000)[1]), candidatedelays)
        loglikel23 = @showprogress pmap(d -> (@suppress gpcc(tobs[[2;3]], yobs[[2;3]], σobs[[2;3]]; kernel = GPCC.matern32, delays = [0;d], iterations = iterations, rhomax = 2000)[1]), candidatedelays)

        filename = "three_lightcurves_pairwise.jld2"

        @printf("Saving results in file %s\n", filename)

        JLD2.save(filename, "candidatedelays", candidatedelays, "loglikel12", loglikel12, "loglikel13", loglikel13, "loglikel23", loglikel23)

    end

end

## Warmup
run_threelightcurves_pairwise(candidatedelays = collect(LinRange(0, 10, nworkers())), iterations = 2)
run_threelightcurves_pairwise(candidatedelays = collect(LinRange(0, 10, nworkers())), iterations = 2)

## Proper run
run_threelightcurves_pairwise()

