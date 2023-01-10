function getposteriordelay3C120_pdf()

    τ, prob = getposteriordelay3C120_pmf()

    p = linear_interpolation(τ, prob, extrapolation_bc = 0.0)

    dx = 1e-4

    Z = 0.0 # normalisation constant

    for τᵢ in minimum(τ):dx:maximum(τ)
        Z += p(τᵢ)*dx
    end

    return τ -> p(τ)/Z

end