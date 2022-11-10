@sync @everywhere begin
    using Pkg
    Pkg.activate(".")
end

@everywhere begin
    using GPCC
    using ProgressMeter, Suppressor, GPCCData, Printf, JLD2, MiscUtil
end


@everywhere function crossvalidation(dataset, delay, kernel; K::Int = 5, iterations::Int = 3000)

    @assert(K>1)

    @printf("Performing %d-CV for dataset %s using kernel %s for delay = %.3f\n", K, dataset, Symbol(kernel), delay)

    
    # load data

    tobs, yobs, σobs, = readdataset(source = dataset)


    # form folds for each lightcurve

    CV1 = CVindices(K = K, N = length(tobs[1]), seed = 1)

    CV2 = CVindices(K = K, N = length(tobs[2]), seed = 2)


    # store here results of cross-validation

    cvresults = zeros(K)


    for k in 1:K

        # indices for training and testing data
        
        tr1, tr2 = taketrainfold(CV1, k), taketrainfold(CV2, k)
        te1, te2 =  taketestfold(CV1, k),  taketestfold(CV2, k)


        # split data into training and testing according to indices

        tobs_tr = [tobs[1][tr1], tobs[2][tr2]]
        yobs_tr = [yobs[1][tr1], yobs[2][tr2]]
        σobs_tr = [σobs[1][tr1], σobs[2][tr2]]

        tobs_te = [tobs[1][te1], tobs[2][te2]]
        yobs_te = [yobs[1][te1], yobs[2][te2]]
        σobs_te = [σobs[1][te1], σobs[2][te2]]


        # train model on training data

        pred = @suppress gpcc(tobs_tr, yobs_tr, σobs_tr; kernel = kernel, iterations=iterations, rhomin=0.01, rhomax = 2000, delays = [0; delay], numberofrestarts=5)[2]
        
        
        # log-likelihood on test data

        cvresults[k] = pred(tobs_te, yobs_te, σobs_te)

    end

    return cvresults

end


function WARMUP()

    @showprogress pmap(d -> (@suppress crossvalidation("3C120", d, GPCC.OU; K = 2, iterations = 3)), 1:2*nworkers())

end


function properrun(dataset, kernel)

    candidatedelays = 0.0:0.2:140

    @showprogress pmap(d -> (@suppress crossvalidation(dataset, d, kernel; K = 5, iterations = 3000)), candidatedelays)

end


function runexperiment1()

    JLD2.save("experiment1.jld2", "results", properrun("3C120", GPCC.OU))

end


function runexperiment2()

    JLD2.save("experiment2.jld2", "results", properrun("3C120", GPCC.matern32))

end