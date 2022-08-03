using JLD2
using Interpolations

# Use as:
# prior = loadprior()
#

function loadprior_z_0_2()

    prior = JLD2.load("prior_z_0.2.jld2", "prior")

    function f(τ)
        
        if τ <= 0.0
        
            return 0.0
        
        elseif τ > 176.15
            
            return 0.0

        end

        return prior(τ)
    end

end