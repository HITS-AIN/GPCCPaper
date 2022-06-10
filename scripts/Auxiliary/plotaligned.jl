using Statistics, StatsFuns, PyPlot

function plotaligned(tobs, yobs; kernel = kernel, delays = delays, rhomax = rhomax, numberofrestarts = 7, iterations = 1000)

    minopt, pred, (α, b, ρ) = gpcc(tobs, yobs, σobs;
        kernel = kernel, delays = delays, iterations = iterations, numberofrestarts = numberofrestarts,
        initialrandom=1, rhomin = 0.1, rhomax = rhomax)

    # b = mean(posterioroffsetb)

    @assert(length(tobs) == length(yobs) == length(delays) == length(b) == length(α) == 2)

    figure()

    PyPlot.plot(tobs[1] .- delays[1], 1 / α[1] * (yobs[1] .- b[1]), "o")

    PyPlot.plot(tobs[2] .- delays[2], 1 / α[2] * (yobs[2] .- b[2]), "o")

    title(@sprintf("%f",delays[2]))


    interval = maximum(maximum.(tobs)) - minimum(minimum.(tobs))

    xtest = minimum(minimum.(tobs)):(interval/1000):maximum(maximum.(tobs))


    PyPlot.plot(xtest .- delays[1], (1 / α[1]) * (pred(xtest)[1][1] .- b[1]))

    PyPlot.plot(xtest .- delays[2], (1 / α[2]) * (pred(xtest)[1][2] .- b[2]), "--")


end
