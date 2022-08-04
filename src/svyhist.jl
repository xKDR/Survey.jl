"""
    sturges(v)

Calculate the number of bins to use in a histogram using the Sturges rule.

# Examples
```jldoctest
julia> sturges(10)
5

julia> sturges([10, 20, 30, 40, 50])
4
```
"""
sturges(n::Integer) = ceil(Int, log2(n)) + 1
sturges(vec::AbstractVector) = ceil(Int, log2(length(vec))) + 1

"""
    sturges(df::DataFrame, var::Symbol)

Calculate the number of bins for a `DataFrame` variable.

# Examples
```jldoctest
julia> using DataFrames

julia> df = DataFrame((a=[1, 2, 3, 4, 5], b=[10, 20, 30, 40, 50]))
5×2 DataFrame
 Row │ a      b
     │ Int64  Int64
─────┼──────────────
   1 │     1     10
   2 │     2     20
   3 │     3     30
   4 │     4     40
   5 │     5     50

julia> sturges(df, :b)
4
```
"""
sturges(df::DataFrame, var::Symbol) = ceil(Int, log2(size(df[!, var], 1))) + 1

"""
    sturges(design::svydesign, var::Symbol)

Calculate the number of bins for a survey design variable.

# Examples
```jldoctest
julia> apistrat = load_data("apistrat");

julia> dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc);

julia> sturges(dstrat, :enroll)
9
```
"""
sturges(design::svydesign, var::Symbol) = sturges(design.variables, var)

"""
	freedman_diaconis(v::AbstractVector)

Calculate the number of bins to use in a histogram using the Freedman-Diaconis rule.

# Examples
```jldoctest
julia> freedman_diaconis([10, 20, 30, 40, 50])
2
```
"""
freedman_diaconis(v::AbstractVector) = round(Int, length(v)^(1 / 3) * (maximum(v) - minimum(v)) / (2 * iqr(v)))

"""
	freedman_diaconis(df::DataFrame, var::Symbol)

Calculate the number of bins for a `DataFrame` variable.

# Examples
```jldoctest
julia> using DataFrames

julia> df = DataFrame((a=[1, 2, 3, 4, 5], b=[10, 20, 30, 40, 50]));

julia> freedman_diaconis(df, :b)
2
```
"""
freedman_diaconis(df::DataFrame, var::Symbol) = freedman_diaconis(df[!, var])

"""
    freedman_diaconis(design::svydesign, var::Symbol)

Calculate the number of bins for a survey design variable.

# Examples
```jldoctest
julia> apistrat = load_data("apistrat");

julia> dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc);

julia> freedman_diaconis(dstrat, :enroll)
15
```
"""
freedman_diaconis(design::svydesign, var::Symbol) = freedman_diaconis(design.variables[!, var])

"""
```julia
svyhist(design, var, bins = freedman_diaconis; normalization = :density, weights = ones(size(design.variables, 1), ...)
```
Histogram plot of a survey design variable given by `var`.

`bins` can be an `Integer` specifying the number of equal-width bins,
an `AbstractVector` specifying the bins intervals, or a `Function` specifying
the function used for calculating the number of bins. The possible functions
are `sturges` and `freedman_diaconis`.

The normalization can be set to `:none`, `:density`, `:probability` or `:pdf`.
See [Makie.hist](https://makie.juliaplots.org/stable/examples/plotting_functions/hist/)
for more information.

The `weights` argument can be an `AbstractVector` or a `Symbol` specifying a
design variable.

For the complete argument list see [Makie.hist](https://makie.juliaplots.org/stable/examples/plotting_functions/hist/).

```@example e1
julia> using Survey

julia> apistrat = load_data("apistrat");

julia> dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc);

julia> h = svyhist(dstrat, :enroll)
```

![](./assets/hist.png)
"""
function svyhist(design::svydesign, var::Symbol,
				 bins::Union{Integer, AbstractVector} = freedman_diaconis(design, var);
				 normalization = :density,
				 weights::Union{Symbol, AbstractVector} = ones(size(design.variables, 1)),
				 kwargs...
				)
	if isa(weights, Symbol)
		weights = design.variables[!, weights]
	end

	hist(design.variables[!, var]; bins = bins, normalization = normalization, weights = weights, kwargs...)
end

function svyhist(design::svydesign, var::Symbol,
				 bins::Function = freedman_diaconis;
				 normalization = :density,
				 weights::Union{Symbol, AbstractVector} = ones(size(design.variables, 1)),
				 kwargs...
				)
	if isa(weights, Symbol)
		weights = design.variables[!, weights]
	end

	hist(design.variables[!, var]; bins = bins(design, var), normalization = normalization, weights = weights, kwargs...)
end
