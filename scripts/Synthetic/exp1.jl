@everywhere using GPCC
using JLD2
using ProgressMeter, Suppressor, Printf


function runme(σ; maxiter=1, numberofrestarts=1)

    tobs, yobs, σobs = simulatetwolightcurves(σ=σ)

    τmax = maximum(maximum.(tobs)) - minimum(minimum.(tobs))

    delays = 0.0:0.1:1.5*τmax

    @printf("Trying out %d delay combinations in parallel\n", length(delays))

    out = @showprogress pmap(τ -> (@suppress gpcc(tobs, yobs, σobs; iterations = maxiter, rhomax = 300, numberofrestarts = numberofrestarts, delays = [0;τ], kernel = GPCC.matern32)[1]), delays)

    return out, delays,tobs, yobs, σobs

end


# warmup
runme(1.0; maxiter=1, numberofrestarts=1)
runme(1.0; maxiter=1, numberofrestarts=1)


function properrun()

    for σ in [0.01; 0.1; 0.2; 0.5; 1.0; 1.5]

        out, delays, tobs, yobs, σobs  = runme(σ; maxiter = 1000, numberofrestarts = 5)

        filename = @sprintf("results_synthetic_%.2f.jld2", σ)

        @printf("Writing results in file %s\n", filename)

        JLD2.save(filename, "out", out, "delays", collect(delays), "tobs", tobs, "yobs", yobs, "σobs", σobs)

    end

end
