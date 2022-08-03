"""
```
	svyplot(design, x, y; weights, kwargs...)
```
Scatter plot of survey design variables `x` and `y`.

Weights can be specified by a `Symbol` or an `AbstractVector` passed to the
keyword argument `weights`.

For the complete argument list see [Makie.scatter](https://makie.juliaplots.org/stable/examples/plotting_functions/scatter/index.html#scatter).

```@example svyplot
julia> using Survey

julia> (; apistrat) = load_data(api);;

julia> dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc);

julia> s = svyplot(dstrat, :api99, :api00; weights = :pw)
```

![](./assets/scatter.png)
"""
function svyplot(design::svydesign, x::Symbol, y::Symbol;
	weights::Union{Symbol, AbstractVector} = ones(size(design.variables, 1)),
	kwargs...
   )
xs = design.variables[!, x]
ys = design.variables[!, y]

if isa(weights, Symbol)
weights = design.variables[!, weights]
end

scatter(xs, ys; markersize = weights, marker = '￮', kwargs...)
end
