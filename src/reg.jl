"""
```julia
apisrs = load_data("apisrs")
srs = SurveyDesign(apisrs)
bsrs = bootweights(srs, replicates = 2000)
glm(@formula(api00~api99), bsrs, Normal())
```
"""
function glm(formula::FormulaTerm, design::ReplicateDesign, args...; kwargs...)
    X = coef(glm(formula, design.data, args...; wts = design.data[!, design.weights], kwargs...))
    Xt = [coef(glm(formula, design.data, args...; wts = design.data[!, "replicate_"*string(i)]), kwargs...) for i in 1:design.replicates]
    Xt = hcat(Xt...)
    SE = [std(Xt[i,:]) for i in 1:size(Xt)[1]]
    DataFrame(Coefficients = X, SE = SE)
end