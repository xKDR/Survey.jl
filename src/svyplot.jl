"""
	svyplot(design, x, y; kwargs...)

Scatter plot of survey design variables `x` and `y`.

The plot takes into account the frequency weights specified by the user
in the design.

```@example svyplot
julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs);

julia> s = svyplot(srs, :api99, :api00)
```

# TODO: change the plot image and example
![](./assets/scatter.png)
"""
function svyplot(design::AbstractSurveyDesign, x::Symbol, y::Symbol; kwargs...)
    data(design.data) * mapping(x, y, markersize = :weights) * visual(Scatter, marker = '￮') |> draw
end

"""
```
	svyplot(design, x, y; kwargs...)
```
Scatter plot of survey design variables `x` and `y`.

The plot takes into account the frequency weights specified by the user
in the design.

```@example svyplot
julia> apistrat = load_data("apistrat");

julia> dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc);

julia> s = svyplot(dstrat, :api99, :api00)
```

![](./assets/scatter.png)
"""
function svyplot(design::svydesign, x::Symbol, y::Symbol; kwargs...)
	data(design.variables) * mapping(x, y, markersize = :weights) * visual(Scatter, marker = '￮') |> draw
end
