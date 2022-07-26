sturges(n::Integer) = ceil(Int, log2(n)) + 1
sturges(vec::AbstractVector) = ceil(Int, log2(length(vec))) + 1
sturges(df::DataFrame, var::Symbol) = ceil(Int, log2(size(df[!, var], 1))) + 1
sturges(design::svydesign, var::Symbol) = sturges(design.variables, var)

freedman_diaconis(v::AbstractVector) = round(Int, length(v)^(1 / 3) * (maximum(v) - minimum(v)) / (2 * iqr(v)))
freedman_diaconis(df::DataFrame, var::Symbol) = freedman_diaconis(df[!, var])
freedman_diaconis(design::svydesign, var::Symbol) = freedman_diaconis(design.variables[!, var])

"""
```julia
svyhist(design, var; bins = :freedman_diaconis, normalization = :density, weights = ones(size(design.variables, 1), ...)
```
Histogram plot of a survey design variable given by `var`.

`bins` can be an `Integer` specifying the number of equal-width bins,
an `AbstractVector` specifying the bins intervals, or a `Symbol` specifying
the function used for calculating the number of bins. The possible symbols for
functions are `:sturges` and `:freedman_diaconis`.

The normalization can be set to `:none`, `:density`, `:probability` or `:pdf`.
See [Makie.hist](https://makie.juliaplots.org/stable/examples/plotting_functions/hist/)
for more information.

The `weights` argument can be an `AbstractVector` or a `Symbol` specifying a
design variable.

For the complete argument list see [Makie.hist](https://makie.juliaplots.org/stable/examples/plotting_functions/hist/).

```julia
julia> using Survey

julia> data(api);

julia> dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc);

julia> h = svyhist(dstrat, :enroll)
```

![](../assets/hist.png)
"""
function svyhist(design::svydesign, var::Symbol;
				 bins::Union{Symbol, Integer, AbstractVector} = :freedman_diaconis,
				 normalization = :density,
				 weights::Union{Symbol, AbstractVector} = ones(size(design.variables, 1)),
				 kwargs...
				)
	if isa(bins, Symbol)
		f = getfield(Main, bins)
		bins = f(design, var)
	end

	if isa(weights, Symbol)
		weights = design.variables[!, weights]
	end

	hist(design.variables[!, var]; bins = bins, normalization = normalization, weights = weights, kwargs...)
end
