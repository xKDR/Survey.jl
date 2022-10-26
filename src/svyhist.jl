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
    sturges(design::SurveyDesign, var::Symbol)

Calculate the number of bins for a `SurveyDesign`.

# Examples
```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs; weights = :pw);

julia> sturges(srs, :enroll)
9
```
"""
sturges(design::AbstractSurveyDesign, var::Symbol) = sturges(design.data, var)

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
    freedman_diaconis(design::SurveyDesign, var::Symbol)

Calculate the number of bins for a `SurveyDesign`.

# Examples
```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs; weights = :pw);

julia> freedman_diaconis(srs, :enroll)
18
```
"""
freedman_diaconis(design::AbstractSurveyDesign, var::Symbol) = freedman_diaconis(design.data[!, var])

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
    svyhist(design, var, bins = freedman_diaconis; normalization = :density, kwargs...)

Histogram plot of a survey design variable given by `var`.

`bins` can be an `Integer` specifying the number of equal-width bins,
an `AbstractVector` specifying the bins intervals, or a `Function` specifying
the function used for calculating the number of bins. The possible functions
are `sturges` and `freedman_diaconis`.

The normalization can be set to `:none`, `:density`, `:probability` or `:pdf`.
See [AlgebraOfGraphics.histogram](https://docs.juliahub.com/AlgebraOfGraphics/CHIaw/0.4.9/generated/datatransformations/#AlgebraOfGraphics.histogram)
for more information.

For the complete argument list see [Makie.hist](https://makie.juliaplots.org/stable/examples/plotting_functions/hist/).

!!! note

    The `weights` argument should be a `Symbol` specifying a design variable.

```@example histogram
apisrs = load_data("apisrs");
srs = SimpleRandomSample(apisrs; weights = :pw);
h = svyhist(srs, :enroll)
save("hist.png", h); nothing # hide
```

![](hist.png)

The histogram plot also supports the old design.

```@example histogram_old
apistrat = load_data("apistrat");
dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc);
h_old = svyhist(dstrat, :enroll)
save("hist_old.png", h_old); nothing # hide
```

![](hist_old.png)
"""
function svyhist(design::AbstractSurveyDesign, var::Symbol,
				 bins::Union{Integer, AbstractVector} = freedman_diaconis(design, var);
				 normalization = :density,
				 kwargs...
    			)
	hist = histogram(bins = bins, normalization = normalization, kwargs...)
	data(design.data) * mapping(var, weights = :weights) * hist |> draw
end

function svyhist(design::AbstractSurveyDesign, var::Symbol,
				 bins::Function;
				 kwargs...
    			)
    svyhist(design, var, bins(design, var); kwargs...)
end

"""
Methods for `svydesign`.
"""
function svyhist(design::svydesign, var::Symbol,
				 bins::Union{Integer, AbstractVector} = freedman_diaconis(design, var);
				 normalization = :density,
				 kwargs...
    			)
	hist = histogram(bins = bins, normalization = normalization, kwargs...)
	data(design.variables) * mapping(var, weights = :weights) * hist |> draw
end

function svyhist(design::svydesign, var::Symbol,
				 bins::Function;
				 kwargs...
    			)
    svyhist(design, var, bins(design, var); kwargs...)
end
