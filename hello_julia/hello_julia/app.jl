module App
# == Packages ==
# set up Genie development environment. Use the Package Manager to install new packages
using GenieFramework
@genietools

# == Code import ==
# add your data analysis code here or in the lib folder. Code in lib/ will be
# automatically loaded
function mean_value(x)
    sum(x) / length(x)
end

# == Reactive code ==
# add reactive code to make the UI interactive
@app begin
    
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
