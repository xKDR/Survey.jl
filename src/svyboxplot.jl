"""
	svyboxplot(design, x, y; kwargs...)

Box plot of survey design variable `y` grouped by column `x`.

Weights can be specified by a `Symbol` using the keyword argument `weights`.

The keyword arguments are all the arguments that can be passed to `mapping` in
[AlgebraOfGraphics](https://docs.juliahub.com/AlgebraOfGraphics/CHIaw/0.4.7/).

```@example svyboxplot
apisrs = load_data("apisrs");
srs = SimpleRandomSample(apisrs; weights = :pw);
bp = svyboxplot(srs, :stype, :enroll; weights = :pw)
save("boxplot.png", bp); nothing # hide
```

![](boxplot.png)
"""
function svyboxplot(design::AbstractSurveyDesign, x::Symbol, y::Symbol; kwargs...)
	map = mapping(x, y; kwargs...)
	data = AlgebraOfGraphics.data(design.data)

	data * visual(BoxPlot) * map |> draw
end

"""
Method for `svydesign`.
"""
function svyboxplot(design::svydesign, x::Symbol, y::Symbol; kwargs...)
    # TODO: change function, make it a wrapper
	map = mapping(x, y; kwargs...)
	data = AlgebraOfGraphics.data(design.variables)

	data * visual(BoxPlot) * map |> draw
end
