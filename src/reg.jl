"""
```julia
apisrs = load_data("apisrs")
srs = SurveyDesign(apisrs)
bsrs = bootweights(srs, replicates = 2000)
glm(@formula(api00~api99), bsrs, Normal())
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