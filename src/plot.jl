"""
	plot(design, x, y; kwargs...)

Scatter plot of survey design variables `x` and `y`.

The plot takes into account the frequency weights specified by the user
in the design.

```julia
julia> using AlgebraOfGraphics

julia> apisrs = load_data("apisrs");

julia> srs = SurveyDesign(apisrs; weights=:pw);

julia> s = plot(srs, :api99, :api00);

julia> save("scatter.png", s)
```

![](assets/scatter.png)
"""
function plot(design::AbstractSurveyDesign, x::Symbol, y::Symbol; kwargs...)
    data(design.data) * mapping(x, y, markersize = design.weights) * visual(Scatter, marker = '￮') |> draw
end
