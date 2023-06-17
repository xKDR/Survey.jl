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
result = svyglm(@formula(api00 ~ api99), bsrs, Normal(), LogitLink())
```
"""

function svyglm(formula::FormulaTerm, design::ReplicateDesign, args...; kwargs...)
    # Compute estimates for model coefficients
    model = glm(formula, design.data, args...; wts = design.data[!, design.weights], kwargs...)
    main_coefs = coef(model)
  
    # Compute replicate models and coefficients
    n_replicates = parse(Int, string(design.replicates))
    rep_models = [glm(formula, design.data, args...; wts = design.data[!, "replicate_"*string(i)]) for i in 1:n_replicates]
    rep_coefs = [coef(model) for model in rep_models] # vector of vectors [n_replicates x [n_coefs]]
    rep_coefs = hcat(rep_coefs...) # matrix of floats [n_coefs x n_replicates]
    n_coefs = size(rep_coefs)[1]
  
    # Compute standard errors of coefficients
    SE = [std(rep_coefs[i,:]) for i in 1:n_coefs]
    DataFrame(Coefficients = main_coefs, SE = SE)
  end