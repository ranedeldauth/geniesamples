module App
# == Packages ==
# set up Genie development environment. Use the Package Manager to install new packages
using GenieFramework
using CellularPotts, PlotlyBase
@genietools

# == Code import ==
# add your data analysis code here or in the lib folder. Code in lib/ will be
# automatically loaded

# == Reactive code ==
# add reactive code to make the UI interactive
@app begin
    @private t = 1
    @private N_cells = 1
    @private division = true
    @out nodeIDs = [[],[]]
    @out trace = [heatmap()]

@async begin
    penalties = [
        AdhesionPenalty([0 20;
                         20 20]),
        VolumePenalty([5]),
        MigrationPenalty(100, [50], (100,100))
       ]

    initialCellState = CellState(:Epithelial, 100, 1)
    space = CellSpace(100,100; periodic=true, diagonal=true)
    cpm = CellPotts(space, initialCellState, penalties)
    cells = collect(1:1)

    for t in 1:100-1
        ModelStep!(cpm)
        sleep(0.1)
        x0 = []
        y0 = []
        x1 = []
        y1 = []

        if 1%40 == 0 && division
            for c in 1:1
                CellDivision!(cpm, c)
            end
            N_cells = cpm.state.cellIDs[end]
            push!(cells, N_cells)
        end

        N_cells = cpm.state.cellIDs[end]
        push!(cells, N_cells)

        trace = [heatmap(z=cpm.space.nodeIDs', colorscale="picnic", showscale="false")]
        nodeIDs = [vec(row) for row in eachrow( cpm.space.nodeIDs')]
    end

end
end

# == Pages ==
# register a new route and the page that will be loaded on access
@page("/", "app.jl.html")
end

# == Advanced features ==
#=
- The @private macro defines a reactive variable that is not sent to the browser.
This is useful for storing data that is unique to each user session but is not needed
in the UI.
    @private table = DataFrame(a = 1:10, b = 10:19, c = 20:29)

=#
