@everywhere begin
    using Pkg
    Pkg.activate(".")
    using GPCC # make sure GPCC is made available to all workers
    using ProgressMeter, Suppressor # need to be independently installed
end


using GPCCData, Printf


function run_threelightcurves(; candidatedelays = collect(0.0:0.05:20))

    lambda, tobs, yobs, σobs = let

        tobs, yobs, σobs, lambda, = readdataset(source = "Mgc0811")

        # select indices that correspond to 5100, 7700 and 9100.0

        idx = [6, 4, 5]

        @printf("Using the following wavelengths:\n")
        display(lambda[idx])

        lambda[idx], tobs[idx], yobs[idx], σobs[idx]

    end


    loglikel = @showprogress pmap(d2 -> map(d1 -> (@suppress gpcc(tobs, yobs, σobs; kernel = GPCC.matern32, delays = [0;d1;d2], iterations = 2000, rhomax = 2000)[1]), candidatedelays), candidatedelays);

    filename = "three_lightcurves.jld2"

    @printf("Saving results in file %s\n", filename)

    JLD2.save(filename, "candidatedelays", candidatedelays, "loglikel", loglikel)

    return candidatedelays, loglikel

end

## Warmup
run_threelightcurves(candidatedelays = collect(LinRange(0, 10, nworkers())))

run_threelightcurves(candidatedelays = collect(LinRange(0, 10, nworkers())))

## Proper run
candidatedelays, loglikel = run_threelightcurves()

#     figure()
#     subplot(311)
#     title("joint posterior")
#     pcolor(candidatedelays,candidatedelays,posterior)
#     ylabel("7700"); xlabel("9100")

#     subplot(312)
#     title("marginal posterior for 7700")
#     plot(candidatedelays,vec(sum(posterior,dims=2)), lw=4)

#     subplot(313)
#     title("marginal posterior for 9100")
#     plot(candidatedelays,vec(sum(posterior,dims=1)), lw = 4)


# end
