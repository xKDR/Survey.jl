"""
```
	svyboxplot(design, x, y; kwargs...)
```
Box plot of survey design variable `y` grouped by column `x`.

Weights can be specified by a Symbol using the keyword argument `weights`.

The keyword arguments are all the arguments that can be passed to `mapping` in
[AlgebraOfGraphics](https://docs.juliahub.com/AlgebraOfGraphics/CHIaw/0.4.7/).

```@example svyboxplot
julia> using survey

julia> data(api);

julia> dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc);

julia> bp = svyboxplot(dstrat, :stype, :enroll; weights = :pw)
```

![](./assets/boxplot.png)
"""
function svyboxplot(design::svydesign, x::Symbol, y::Symbol; kwargs...)
	map = mapping(x, y; kwargs...)
	data = AlgebraOfGraphics.data(design.variables)

	data * visual(BoxPlot) * map |> draw
end
