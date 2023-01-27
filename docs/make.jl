using Survey
using Documenter
using Random

DocMeta.setdocmeta!(Survey, :DocTestSetup, :(using Survey); recursive=true)

makedocs(;
    modules=[Survey],
    authors="xKDR Forum",
    # doctest = :fix, 
    repo="https://github.com/xKDR/Survey.jl/blob/{commit}{path}#{line}",
    sitename="$Survey.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://xKDR.github.io/Survey.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Getting Started" => "getting_started.md",
        "Manual" => [
            "DataFrames in Survey" => "man/dataframes.md",
            "ReplicateDesign" => "man/replicate.md",
            "Plotting" => "man/plotting.md",
            "Comparison with other languages" => "man/comparisons.md",
            "Future plans" => "man/future.md",
        ],
        "API reference" => "api.md",
    ],
    checkdocs=:exports,
)

deploydocs(;
    repo="github.com/xKDR/Survey.jl",
    target="build",
    devbranch="main",
)
