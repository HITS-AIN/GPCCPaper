function getupperdelay_conditional(; z = z, bhm = bhm, eta = 0.1, edfrac = edfrac)
    
    lum = masslumfunction(;bhm = bhm, edfrac = edfrac, eta = eta)

    f(L,z) = 10.0^(1.559)*(L/10 * 10^(-44))^(0.549) * (1 + z)

    f(lum,z)
    
end


function masslumfunction(; bhm = 1e8, edfrac = 10.0, eta = 0.1)

    year = 3.15569e7 #seconds in a year
    c    = 2.99792458e10 # speed of light in cm s-1
    g    = 6.67259e-8 #Gravitational constant in cm3 gram-1 s-2
    proton_mass = 1.6726231e-24 # in grams
    thscs       = 0.665e-24 # cm2 # Thompson scattering cross-section per electron --> (Thompson opacity = thscs / proton_mass = 0.397579 cm2 gram-1)
    const_edd   = (4.0 * pi * g * c * proton_mass)/thscs #constant for the eddington luminosity
    sun_mass_gm = 1.989e33 #solar mass in grams
    eddlumin  = const_edd * bhm * sun_mass_gm  #Eddington Luminosity in (erg/s)
    eddrate   = eddlumin/(eta*c^2.0) * year/sun_mass_gm #Eddington mass accretion rate limit
    lum       = edfrac/100.0 * eddlumin

    return lum

end


function sampleparameters(mix)
    
    a, b = rand(mix)
    
    edfrac = (10^a) * 100
    
    bhm = 10^b

    return edfrac, bhm

end


function getupperdelay(mix,z)

    edfrac, bhm = sampleparameters(mix)

    getupperdelay_conditional(; z = z, bhm = bhm, eta = 0.1, edfrac = edfrac)

end


function sampledelay(mix, z)

    rand()*getupperdelay(mix, z)

end

