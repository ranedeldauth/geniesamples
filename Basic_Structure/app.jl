module App
# == Packages ==
# set up Genie development environment. Use the Package Manager to install new packages
using GenieFramework
using Random
@genietools

function random_value()
    return rand(-1000:1000);
end

@app begin
    @in click = false
    @out value = 0


    @onbutton click begin
        value = random_value()
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
