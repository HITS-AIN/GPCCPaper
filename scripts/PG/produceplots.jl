using Printf, GPCC, PlotlyJS, JLD2


function produceplot(filename::String, exportfilename = "")

    data = JLD2.load(filename)

    layout = Layout(title=filename)

    prob = getprobabilities(data["cvresults"])

    fig = plot(scatter(x = data["delays"], y = prob), layout)

    if ~isempty(exportfilename)

        @printf("Exporting figure to file called %s\n", exportfilename)

        open(exportfilename, "w") do io
            PlotlyBase.to_html(io, fig.plot)
        end

    end

    return fig

end


function exportallplots()

    datasets = ["pg0026", "pg0052", "pg0804"]

    for d in datasets

        display(d)

        filename = "results_"*d*"OU().jld2"

        out = d * "delays.html"

        produceplot(filename, exportfilename = out)

    end

end