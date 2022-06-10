using GPCC, Printf, PyPlot, JLD2

function plotsyntheticresults()

    figure()

    for (index, σ) in enumerate([0.01; 0.25; 0.5; 0.75; 1.0; 1.25; 1.5; 2.0])

        filename = @sprintf("results_synthetic_%.2f.jld2", σ)

        @printf("Loading file %s\n", filename)

        results, delays = JLD2.load(filename, "out", "delays")

        subplot(8, 2, index)

        title(string(σ))

        plot(delays, getprobabilities(results))

    end

end
