function approximate_cdf_prior_with_net(d, P; maxiter=10)

    maxd = maximum(d)

    targets = P.(d)

    inputs = reshape(d,1,length(d))

    σ(x) = 1.0 / (1 + exp(-x))


    net = [layer(1, 5, x->σ.(x)); layer(5, 1, x-> tanh.(x/maxd))]


    function obj(w)

        local pred = vec( net(w, inputs) )

        sum((pred .- targets).^2) + 1e-6*sum(w.^2)

    end


    opt = Optim.Options(iterations = maxiter, show_trace = true)

    w = optimize(obj, randn(numweights(net)), LBFGS(), opt, autodiff=:forward).minimizer


    f(d) = only(net(w,d)) # cdf

end