using Distributions, Random

function squarednormal(; μ = μ, σ = σ)

    normaldensity = Normal(μ, σ)

    function transformeddensity(y)

        if y <= 0
            return 0.0
        end
        
        pdf(normaldensity, +sqrt(y)) / abs(2*sqrt(y)) + 
        pdf(normaldensity, -sqrt(y)) / abs(2*sqrt(y))

    end

end