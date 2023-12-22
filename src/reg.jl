"""
    glm(formula::FormulaTerm, design::ReplicateDesign, args...; kwargs...)

Perform generalized linear modeling (GLM) using the survey design with replicates.

# Arguments
- `formula`: A `FormulaTerm` specifying the model formula.
- `design`: A `ReplicateDesign` object representing the survey design with replicates.
- `args...`: Additional arguments to be passed to the `glm` function.
- `kwargs...`: Additional keyword arguments to be passed to the `glm` function.

# Returns
A `DataFrame` containing the estimates for model coefficients and their standard errors.

# Example
```julia
apisrs = load_data("apisrs")
srs = SurveyDesign(apisrs)
bsrs = bootweights(srs, replicates = 2000)
result = glm(@formula(api00 ~ api99), bsrs, Normal())
```

```jldoctest; setup = :(using Survey, StatsBase, GLM; apisrs = load_data("apisrs"); srs = SurveyDesign(apisrs); bsrs = bootweights(srs, replicates = 2000);)
julia> glm(@formula(api00 ~ api99), bsrs, Normal())
2×2 DataFrame
 Row │ estimator  SE        
     │ Float64    Float64   
─────┼──────────────────────
   1 │ 63.2831    9.41231
   2 │  0.949762  0.0135488
```
"""
function glm(formula::FormulaTerm, design::ReplicateDesign, args...; kwargs...)

    rhs_symbols = typeof(formula.rhs) == Term ? Symbol.(formula.rhs) : collect(Symbol.(formula.rhs))
    lhs_symbols = Symbol.(formula.lhs)
    columns = vcat(rhs_symbols, lhs_symbols)

    function inner_glm(df::DataFrame, columns, weights_column, args...; kwargs...)
        matrix = hcat(ones(nrow(df)), Matrix(df[!, columns[1:(length(columns)-1)]]))
        model = glm(matrix, (df[!, columns[end]]), args...; wts=df[!, weights_column], kwargs...)
        return coef(model)
    end

    # Compute standard error of coefficients
    standarderror(columns, inner_glm, design, args...; kwargs...)
  end