using Printf

names = ["Mrk335","Mrk1501","3C120","Mrk6","PG2130099"]

redshift = [0.0258; 0.0893; 0.0330; 0.0188; 0.0630]

lum = [5.01e43; 2.09e44; 9.12e43; 5.62e43; 1.41e44]

f(L,z)              = 10.0^(1.559)*(L    * 10^(-44))^(0.549) * (1 + z)

f_divide_by_10(L,z) = 10.0^(1.559)*(L/10 * 10^(-44))^(0.549) * (1 + z)


for (n, z, l) in zip(names, redshift, lum)

    @printf("Prior for %s is [0,%2.3f]\n\n", n, f(l,z))

end


for (n, z, l) in zip(names, redshift, lum)

    @printf("Divide by 10: Prior for %s is [0,%2.3f]\n\n", n, f_divide_by_10(l,z))

end

