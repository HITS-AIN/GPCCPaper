function simulatedata(;seed = 1)


    rg = MersenneTwister(seed)

    #---------------------------------------------------------------------
    # Define GP parameters
    #---------------------------------------------------------------------

    ρ = 3.5 # lengthscale

    truedelays = [0.0; 3.0; 6.0]

    α  = [1; 1.5;   2.0] # scaling coefficients

    b  = [6; 15.0; 25.0] # offset coefficients

    σ  = [0.5; 0.5; 0.5]

    #---------------------------------------------------------------------
    # Data generation parameters
    #---------------------------------------------------------------------

    N = [40; 40; 40] # number of data items per band

    t = [rand(rg, N[1])*20, rand(rg, N[2])*20, rand(rg, N[3])*20]


    #---------------------------------------------------------------------
    # Define Gaussian process to draw noisy targets
    #---------------------------------------------------------------------

    C = GPCC.delayedCovariance(GPCC.OU, α, truedelays, ρ, t)

    let

        U, S, V = svd(C)

        C = U * Diagonal(max.(1e-6, abs.(S))) * U'

        makematrixsymmetric!(C)

    end


    #---------------------------------------------------------------------
    # Draw targets and arrange in array
    #---------------------------------------------------------------------

    Y = rand(rg, MvNormal(zeros(sum(N)), C))

    y = Vector{Vector{Float64}}(undef, length(truedelays))

    mark = 0

    for i in eachindex(truedelays)

        y[i] = Y[mark+1:mark+N[i]] * α[i] .+ b[i] .+ σ[i]*randn(rg, N[i])

        mark += N[i]

    end

    return t, y, [σ[i]*ones(size(y[i])) for i in 1:3], truedelays, α, b


end