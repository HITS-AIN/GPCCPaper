function plotsamples(tobs, yobs; kernel = kernel, delays = delays, rhomax = rhomax, numberofrestarts = 7, iterations = 1000, numsamples = 3)

    pred = gpcc(tobs, yobs, σobs;
        kernel = kernel, delays = delays, iterations = iterations, numberofrestarts = numberofrestarts,
        initialrandom=1, rhomin = 0.1, rhomax = rhomax)[2]



    interval = maximum(maximum.(tobs)) - minimum(minimum.(tobs))

    xtest = minimum(minimum.(tobs)):(interval/1000):maximum(maximum.(tobs))

    mu,Sigma = pred([xtest for i in 1:2])

    for i in 1:numsamples

        figure()

        PyPlot.plot(xtest, rand(MvNormal(mu[1:length(xtest)],Sigma[1:length(xtest), 1:length(xtest)])),label="sample cont")

        PyPlot.plot(xtest, rand(MvNormal(mu[length(xtest)+1:2length(xtest)],Sigma[length(xtest)+1:2length(xtest), length(xtest)+1:2length(xtest)])), label="sample hb")

        PyPlot.plot(tobs[1], yobs[1],"co")

        PyPlot.plot(tobs[2], yobs[2],"ro")

    end

end
