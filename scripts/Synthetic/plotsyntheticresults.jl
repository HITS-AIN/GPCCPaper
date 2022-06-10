using GPCC, Printf, PyPlot, JLD2

function plotsyntheticresults()

    figure()

    for (index, σ) in enumerate([0.01; 0.1; 0.2; 0.5; 1.0; 1.5])

        filename = @sprintf("results_synthetic_%.2f.jld2", σ)

        @printf("Loading file %s\n", filename)

        results, delays = JLD2.load(filename, "out", "delays")

        subplot(3, 2, index)

        title(@sprintf("σ=%.2f", σ), fontsize=8)

        plot(delays, getprobabilities(results))

    end

    figure()

    for (index, σ) in enumerate([0.01; 0.1; 0.2; 0.5; 1.0; 1.5])

        subplot(3, 2, index)


        tobs, yobs, σobs = simulatedata(σ=σ)
        close()

        title(@sprintf("σ=%.2f", σ), fontsize=8)

        for i in 1:2
            errorbar(tobs[i], yobs[i], yerr=2σobs[i], fmt="o")
        end

    end

end
