using Survey
using Documenter

DocMeta.setdocmeta!(Survey, :DocTestSetup, :(using Survey); recursive=true)

makedocs(;
    modules=[Survey],
    authors="xKDR Forum",
    repo="https://github.com/xKDR/Survey.jl/blob/{commit}{path}#{line}",
    sitename="$Survey.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://xKDR.github.io/Survey.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Examples" => "examples.md",
        "Comparison with R" => "R_comparison.md",
        "Performance" => "performance.md",
    ],
)

deploydocs(;
    repo="github.com/xKDR/Survey.jl",
    target = "build",
    devbranch="main"
)
