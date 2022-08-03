
function readdata()

    f = FITS("/home/nikos/Dropbox/Documents/Research/ReverberationBLR/Quasar_Data/SDSS/dr14/dr14q_spec_prop.fits");

    loged = read(f[2], "LOG_REDD");
    
    edflag = read(f[2], "QUALITY_REDD");

    idx1 = findall(edflag.==0);

    logbhm = read(f[2], "LOG_MBH");

    bhmflag = read(f[2], "QUALITY_MBH");

    idx2 = findall(bhmflag .== 0);

    idx0 = intersect(idx1, idx2);

    [loged[idx0] logbhm[idx0]]

end


function readdatagivenz(z, tol)

    f = FITS("/home/nikos/Dropbox/Documents/Research/ReverberationBLR/Quasar_Data/SDSS/dr14/dr14q_spec_prop.fits");

    redshift = read(f[2], "REDSHIFT");

    loged = read(f[2], "LOG_REDD");
    
    edflag = read(f[2], "QUALITY_REDD");

    idx1 = findall(edflag.==0);

    logbhm = read(f[2], "LOG_MBH");

    bhmflag = read(f[2], "QUALITY_MBH");

    idx2 = findall(bhmflag .== 0);

    idx3 = findall(redshift .>= z-tol);
    
    idx4 = findall(redshift .<= z+tol);


    idx0 = intersect(idx1, idx2, idx3, idx4);

    [loged[idx0] logbhm[idx0] redshift[idx0]]

end