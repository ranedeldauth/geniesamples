module App
# == Packages ==
# set up Genie development environment. Use the Package Manager to install new packages
using GenieFramework
using StippleLatex
using DifferentialEquations
using ModelingToolkit
@genietools

function recalc()
    @parameters t s r b
    @variables x(t) y(t) z(t)
    D = Differential(t)

# Lorenz Chaos Equations
eqs = [D(x) ~ s * (y - x),
D(y) ~ x * (r - z) - y,
D(z) ~ x * y - b * z]

# Shuffle them in on ODE
    sys = structural_simplify(ODESystem(eqs))
    u0 = [x => 1.0, y => 0.0, z => 0.0]
    p = [s => 10.0, r => 28.0, b => 8 / 3]

    tspan = (0.0, 100.0)
    ODEProblem(sys, u0, tspan, p, jac=true)
end

# == Reactive code ==
# add reactive code to make the UI interactive
@app begin

@private data = DifferentialEquations.init(recalc(), Tsit5())

@in s = 10
@in r = 28.0
@in b = 8 / 3

@out t::Float64 = 0.0
@in t_step = 0.25
@in t_end = 255
@in start = false
@out solplot = PlotData()
@out layout = PlotLayout(
    xaxis=[PlotLayoutAxis(xy="x", title="x")],
    yaxis=[PlotLayoutAxis(xy="y", title="y")])
@private u_x = []
@private u_y = []

DifferentialEquations.reinit!(data)

u_x = []
u_y = []
t = 0.0

@async begin
    while t <= t_end
        sleep(t_step)
        solplot = PlotData(x=u_x, y=u_y, z=u_x, plot=StipplePlotly.Charts.PLOT_TYPE_LINE)
        data.p[1] = s
        data.p[2] = r
        data.p[3] = b
        step!(data, t_step, true)
        l = length(data.sol.u)
        append!(u_x, [u[1] for u in data.sol.u[l:end]][:])
        append!(u_y, [u[2] for u in data.sol.u[l:end]][:])
        t = data.sol.t[end]
    end
    running = false
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
