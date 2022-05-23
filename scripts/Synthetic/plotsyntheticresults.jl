function plotsyntheticresults(jldfile)

    out = JLD2.load(jldfile)["results"]

    delays = formdelays(1)

    G = [collect(a) for a in delays]

    G1 = [g[1] for g in G]
    G2 = [g[2] for g in G]

    prob = reshape(getprobabilities(out), size(out))

    figure()

    subplot(311); cla()
    pcolor(G1, G2, prob)

    subplot(312); cla()
    plot(G1[:,1], vec(sum(prob, dims=2)))

    subplot(313); cla()
    plot(G1[:,1], vec(sum(prob, dims=1)))


end
