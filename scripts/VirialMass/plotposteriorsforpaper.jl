using GLMakie, CairoMakie, JLD2, GPCC, Distributions

function plotposterior(file, prior::Uniform, figname)

    τmax = maximum(prior)

    GLMakie.activate!()

    cvresults0, delays0 = JLD2.load(file,"cvresults","delays")

    delays1 = map(only, delays0)

    τmax = min(maximum(prior), maximum(delays1))

    delays = let

        tmp = map(only, delays0)

        tmp[findall(tmp .< τmax)]

    end

    cvresults = let
        
        tmp = map(only, delays0)

        cvresults0[findall(tmp .< τmax)]

    end

    

    # add log prior to form log joint likelihood
    for i in eachindex(delays)
        
        cvresults[i] .+= log(pdf(prior, delays[i]))

    end

    fig = Figure(resolution=(3800,2400/2),fontsize = 44)

    display(fig) 

    ax = Axis(fig[1,1],title = "", xlabel = "delay in days", ylabel = L"\mathbf{\pi^{(CV)}}", ylabelsize = 64)
    
    ax.xticks = LinearTicks(30)

    ax.yticks = LinearTicks(5)

    xlims!(ax, 0, τmax*1.01) #; ylims!(ax, 0.3, maxy)

    lines!(ax, delays, GPCC.getprobabilities(cvresults), linewidth=4) 

    CairoMakie.activate!()
    
    save(figname, fig)

    GLMakie.activate!()

    fig
end

# prior = Uniform(0, 1e6) # simulates flat prior
# prior = uniformpriordelay(L=9.12e43,z=0.0330) # prior from paper
# plotposterior("results_GPCC@0.1.28_PG2130099_date_2022-07-20_rho_1165.946651854911_K_OU_Dt_0.05_R_10.jld2",prior,"posterior_PG2130099_flatprior.png")
# plotposterior("results_GPCC@0.1.28_Mrk6_date_2022-07-20_rho_3530.3767187344483_K_OU_Dt_0.05_R_10.jld2",prior,"posterior_mrk6_flatprior.png")
# plotposterior("results_GPCC@0.1.28_3C120_date_2022-07-20_rho_198.81700740188887_K_OU_Dt_0.05_R_10.jld2",prior,"posterior_3c120_flatprior.png")
# plotposterior("results_GPCC@0.1.28_Mrk1501_date_2022-07-20_rho_2393.4875254984754_K_OU_Dt_0.05_R_10.jld2",prior,"posterior_mrk1501_flatprior.png")
# plotposterior("results_GPCC@0.1.28_Mrk335_date_2022-07-20_rho_1439.7057982017648_K_OU_Dt_0.05_R_10.jld2",prior,"posterior_mrk335_flatprior.png")
