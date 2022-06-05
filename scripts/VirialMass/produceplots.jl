using Printf, GPCC, PlotlyJS, JLD2



function getprob(cvresults)

    aux = mean.(cvresults)

    pr = exp.(aux .- logsumexp(aux))

    pr / sum(pr) # sometimes pr will not sum up to 1 exactly, this line helps

end

function produceplot(filename::String, exportfilename = "")

    data = JLD2.load(filename)

    prob = getprob(data["cvresults"])

    layout = Layout(title=filename)

    fig = PlotlyJS.plot(PlotlyJS.scatter(x = vec([only(d) for d in data["delays"]]), y = prob), layout)

    if ~isempty(exportfilename)

        @printf("Exporting figure to file called %s\n", exportfilename)

        open(exportfilename, "w") do io
            PlotlyBase.to_html(io, fig.plot)
        end

    end

    display(fig)

    nothing

end


function produceallplots(exporthtmlfigures = false)

    for d in listvirialdatasets()

        display(d)

        filename = "results_"*d*"_500.00_OU().jld2"

        if exporthtmlfigures

            produceplot(filename, d * "delays.html")

        else

            produceplot(filename)

        end

    end

end
