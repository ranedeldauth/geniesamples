module App
# == Packages ==
# set up Genie development environment. Use the Package Manager to install new packages
using TextEncodeBase, LinearAlgebra

# BERT Algorithm
using Transformers
using Transformers.TextEncoders
using Transformers.HuggingFace

# Plot Caclulation
using PlotlyBase
using StatsBase
using MultivariateStats

using GenieFramework
@genietools

# == Reactive code ==
# add reactive code to make the UI interactive
@app begin
    @in shift = false
    @in text = " "
    @out result_data = [heatmap()]

    @onbutton shift begin
        textencoder, bert_model = hgf"bert-base-uncased" # Prepare for BERT
        encoded_text = encode(textencoder, text) # Encode
 
        # Final
        algo = bert_model(encoded_text).hidden_state[:, 2:end-1]
        gen_text = [string(string(i) * "." * t.x) for (i, t) in enumerate(TextEncodeBase.tokenize(textencoder, text))]

        text_length = length(gen_text)
        matrix = zeros(text_length, text_length)

        function cosine_similarity(a, b)
            dot(a, b) / (norm(a) * norm(b))
        end

        for i in 1:text_length
            for j in 1:text_length
                matrix[i,j] = cosine_similarity(algo[:, i], algo[:, j])
            end
        end

        final_matrix = [matrix[:, i] for i in text_length]

        result_data = [heatmap(
            z = final_matrix, x = gen_text, y = gen_text
        )]
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
