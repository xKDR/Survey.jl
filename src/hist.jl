sturges(n::Integer) = ceil(Int, log2(n)) + 1
sturges(vec::AbstractVector) = ceil(Int, log2(length(vec))) + 1
sturges(df::DataFrame, var::Symbol) = ceil(Int, log2(size(df[!, var], 1))) + 1
sturges(design::design, var::Symbol) = sturges(design.variables, var)

"""
    sturges(design::SurveyDesign, var::Symbol)

Calculate the number of bins to use in a histogram using the Sturges rule.

# Examples
```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs;popsize=:fpc);

julia> sturges(srs, :enroll)
9
```
"""
sturges(design::AbstractSurveyDesign, var::Symbol) = sturges(design.data, var)

freedman_diaconis(v::AbstractVector) = round(Int, length(v)^(1 / 3) * (maximum(v) - minimum(v)) / (2 * iqr(v)))
freedman_diaconis(df::DataFrame, var::Symbol) = freedman_diaconis(df[!, var])
freedman_diaconis(design::design, var::Symbol) = freedman_diaconis(design.variables[!, var])

"""
    freedman_diaconis(design::SurveyDesign, var::Symbol)

Calculate the number of bins to use in a histogram using the Freedman-Diaconis rule.

# Examples
```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs;popsize=:fpc);

julia> freedman_diaconis(srs, :enroll)
18
```
"""
freedman_diaconis(design::AbstractSurveyDesign, var::Symbol) = freedman_diaconis(design.data[!, var])

"""
    hist(design, var, bins = freedman_diaconis; normalization = :density, kwargs...)

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
srs = SimpleRandomSample(apisrs;popsize=:fpc);
h = hist(srs, :enroll)
save("hist.png", h); nothing # hide
```

![](assets/hist.png)
"""
function hist(design::AbstractSurveyDesign, var::Symbol,
				 bins::Union{Integer, AbstractVector} = freedman_diaconis(design, var);
				 normalization = :density,
				 kwargs...
    			)
	hist = histogram(bins = bins, normalization = normalization, kwargs...)
	data(design.data) * mapping(var, weights = :weights) * hist |> draw
end

function hist(design::AbstractSurveyDesign, var::Symbol,
				 bins::Function;
				 kwargs...
    			)
    hist(design, var, bins(design, var); kwargs...)
end

function hist(design::design, var::Symbol,
				 bins::Union{Integer, AbstractVector} = freedman_diaconis(design, var);
				 normalization = :density,
				 kwargs...
    			)
	hist = histogram(bins = bins, normalization = normalization, kwargs...)
	data(design.variables) * mapping(var, weights = :weights) * hist |> draw
end

function hist(design::design, var::Symbol,
				 bins::Function;
				 kwargs...
    			)
    hist(design, var, bins(design, var); kwargs...)
end
