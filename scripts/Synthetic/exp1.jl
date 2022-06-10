@everywhere using GPCC
using JLD2
using ProgressMeter, Suppressor, Printf


function runme(σ; maxiter=1, numberofrestarts=1)

    tobs, yobs, σobs = simulatedata(σ=σ)

    τmax = maximum(maximum.(tobs)) - minimum(minimum.(tobs))

    delays = 0.0:0.1:1.5*τmax

    @printf("Trying out %d delay combinations in parallel\n", length(delays))

    out = @showprogress pmap(τ -> (@suppress performcv(tobs, yobs, σobs; iterations = maxiter, numberofrestarts = numberofrestarts, delays = [0;τ], kernel = GPCC.matern32)), delays)

    return out, delays

end


# warmup
runme(1.0; maxiter=1, numberofrestarts=1)
runme(1.0; maxiter=1, numberofrestarts=1)


function properrun()

<<<<<<< HEAD
    for σ in [0.01; 0.25; 0.5; 0.75; 1.0; 1.25; 1.5, 2.0]
=======
    for σ in [0.01; 0.25; 0.5; 0.75; 1.0; 1.25; 1.5]
>>>>>>> acbc824915ba8f56ca8096cc8cb01a85ae34db73

        out, delays = runme(σ; maxiter = 1000, numberofrestarts = 3)

        filename = @sprintf("results_synthetic_%.2f.jld2", σ)

        @printf("Writing results in file %s\n", filename)

        JLD2.save(filename, "out", out, "delays", delays)

    end

end
