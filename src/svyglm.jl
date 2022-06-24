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

julia> dclus1 = svydesign(id=:dnum, weights=:pw, data = apiclus1, fpc=:fpc); 

julia> svyglm(@formula(ell~meals),dclus1,Normal(),IdentityLink())
StatsModels.TableRegressionModel{GLM.GeneralizedLinearModel{GLM.GlmResp{Vector{Float64}, Normal{Float64}, IdentityLink}, GLM.DensePredChol{Float64, LinearAlgebra.Cholesky{Float64, Matrix{Float64}}}}, Matrix{Float64}}

ell ~ 1 + meals

Coefficients:
────────────────────────────────────────────────────────────────────────
                Coef.  Std. Error      z  Pr(>|z|)  Lower 95%  Upper 95%
────────────────────────────────────────────────────────────────────────
(Intercept)  6.86665   0.350512    19.59    <1e-84   6.17966    7.55364
meals        0.410511  0.00613985  66.86    <1e-99   0.398477   0.422545
────────────────────────────────────────────────────────────────────────
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
        out
    end

    function svyglm(formula, design, dist, link)
        data = design.data
        rtol = 1e-8
        atol = 1e-8
        maxiter = 30
        if design.probs != Symbol("")
            weights = (1.0 ./ data[:,design.probs])
        else
            weights = ones(size(data)[1])
        end
        if design.weights != Symbol("")
            weights .*= data[:,design.weights]
        end
        glmout = glm(formula, data, dist, link, wts = weights, rtol = rtol, atol = atol, maxiter = maxiter)
        svyglm_cons(glmout, data, weights,rtol,atol,maxiter)
    end
end

function Base.show(io::IO, g::svyglm)
    print(g.glm)
end