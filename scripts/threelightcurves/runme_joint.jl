@everywhere begin
    using Pkg
    Pkg.activate(".")
    using GPCC # make sure GPCC is made available to all workers
    using ProgressMeter, Suppressor # need to be independently installed
end


using GPCCData, Printf, JLD2


function run_threelightcurves_joint(; candidatedelays = collect(0.0:0.1:10), iterations = 2000)

    lambda, tobs, yobs, σobs = let

        tobs, yobs, σobs, lambda, = readdataset(source = "Mgc0811")

        # select indices that correspond to 5100, 7700 and 9100.0

        idx = [6, 4, 5]

        @printf("Using the following wavelengths:\n"); display(lambda[idx])

        lambda[idx], tobs[idx], yobs[idx], σobs[idx]

    end

    let

        loglikel = @showprogress pmap(d2 -> map(d1 -> (@suppress gpcc(tobs, yobs, σobs; kernel = GPCC.matern32, delays = [0;d1;d2], iterations = iterations, rhomax = 2000)[1]), candidatedelays), candidatedelays);

        filename = "three_lightcurves_joint.jld2"

        @printf("Saving results in file %s\n", filename)

        JLD2.save(filename, "candidatedelays", candidatedelays, "loglikel", loglikel)

    end

end

## Warmup
run_threelightcurves_joint(candidatedelays = collect(LinRange(0, 10, nworkers())), iterations = 2)

run_threelightcurves_joint(candidatedelays = collect(LinRange(0, 10, nworkers())), iterations = 2)

## Proper run
run_threelightcurves_joint()

