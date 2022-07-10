mutable struct control
    rtol
    atol
    maxiter
end

"""
```julia
svyglm(formula, design, dist, link)
```

The `svyglm` function can be used to fit glms on svydesign.

```jldoctest
julia> using Survey      

julia> data(api); 

julia> dclus1 = svydesign(id=:dnum, weights=:pw, data = apiclus1); 

julia> svyglm(@formula(ell~meals),dclus1,Normal(),IdentityLink())

```
"""
mutable struct svyglm
    glm
    coefficients
    data
    weights #wrkwts
    aic
    family
    rank
    formula 
    model #subset of data as described in formula
    deviance
    offset
    y
    linear_predictors
    fitted_values
    prior_weights #initial weights
    residuals
    converged
    control
    terms
    contrasts
    function svyglm_cons(glm, data, weights,rtol,atol,maxiter)
        out = new()
        out.glm = glm
        out.coefficients = coef(glm)
        out.data = data
        out.weights = glm.model.rr.wrkwt
        out.aic = aic(glm)
        out.family = glm.model.rr.d
        out.rank = rank(glm.model.pp.X)
        out.formula = formula(glm)
        out.model = glm.mf.data
        out.deviance = deviance(glm)
        out.offset = glm.model.rr.offset
        out.y = glm.model.rr.y
        out.linear_predictors = predict(glm)
        out.fitted_values = fitted(glm)
        out.prior_weights = weights
        out.residuals = glm.model.rr.wrkresid
        out.converged = true
        out.control = control(rtol,atol,maxiter)
        out.terms = glm.mf.f
        out.contrasts = []
        out
    end

    function svyglm(formula, design, dist, link)
        data = design.variables
        rtol = 1e-8
        atol = 1e-8
        maxiter = 30
        glmout = glm(formula, data, dist, link, wts = 1 ./ data.probs, rtol = rtol, atol = atol, maxiter = maxiter)
        svyglm_cons(glmout, data, weights,rtol,atol,maxiter)
    end
end

function Base.show(io::IO, g::svyglm)
    print(g.glm)
end