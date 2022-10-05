#using Distributed

#addprocs(8) 

@everywhere using GPCC # make sure GPCC is made available to all workers

@everywhere using ProgressMeter, Suppressor # need to be independently installed

using ADDatasets

using PyPlot # we need this to plot the posterior probabilities, must be independently installed

plt.rc("font", size=30)


candidatedelays = collect(0.0:0.05:20)


lambda, tobs, yobs, σobs = let

    lambda, tobs, yobs, σobs = readdataset(source = "Mgc0811")

    # select indices that correspond to 5100, 7700 and 9100.0
    idx = [6, 4, 5]

    lambda[idx], tobs[idx], yobs[idx], σobs[idx]

end


# warmup

let 
    for i in 1:2
        @showprogress pmap(d2 -> map(d1 -> (@suppress gpcc(tobs, yobs, σobs; kernel = GPCC.matern32, delays = [0;d1;d2], iterations = 10, rhomax = 300)[1]), candidatedelays[1:10]), candidatedelays[1:2*nworkers()]);
    end
end

out = @showprogress pmap(d2 -> map(d1 -> (@suppress gpcc(tobs, yobs, σobs; kernel = GPCC.matern32, delays = [0;d1;d2], iterations = 2000, rhomax = 2000)[1]), candidatedelays), candidatedelays);

posterior = getprobabilities(reduce(vcat, out));

posterior = reshape(posterior, length(candidatedelays), length(candidatedelays));

figure()
subplot(311)
title("joint posterior")
pcolor(candidatedelays,candidatedelays,posterior)
ylabel("7700"); xlabel("9100")

subplot(312)
title("marginal posterior for 7700")
plot(candidatedelays,vec(sum(posterior,dims=2)), lw=4)

subplot(313)
title("marginal posterior for 9100")
plot(candidatedelays,vec(sum(posterior,dims=1)), lw = 4)
