"""
svyglm(formula::FormulaTerm, design::ReplicateDesign, args...; kwargs...)

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
result = svyglm(@formula(api00 ~ api99), bsrs, Normal())
```
"""

function svyglm(formula::FormulaTerm, design::ReplicateDesign, args...; kwargs...)

    rhs_symbols = typeof(formula.rhs) == Term ? Symbol.(formula.rhs) : collect(Symbol.(formula.rhs))
    lhs_symbols = Symbol.(formula.lhs)
    columns = vcat(rhs_symbols, lhs_symbols)

    function inner_svyglm(df::DataFrame, columns, weights_column, args...; kwargs...)
        matrix = hcat(ones(nrow(df)), Matrix(df[!, columns[1:(length(columns)-1)]]))
        model = glm(matrix, (df[!, columns[end]]), args...; wts=df[!, weights_column], kwargs...)
        return coef(model)
    end

    # Compute variance of coefficients
    variance(columns, inner_svyglm, design, args...; kwargs...)
  end