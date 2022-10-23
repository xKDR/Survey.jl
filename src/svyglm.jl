function nullformula(f)
    FormulaTerm(f.lhs,ConstantTerm(1))
end

mutable struct control
    rtol
    atol
    maxiter
end

"""
    svyglm(formula, design, dist, link)

Fit Generalized Linear Models (GLMs) on `svydesign`.

```jldoctest
julia> apiclus1 = load_data("apiclus1");

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
    naive_cov
    df_null
    null_deviance
    df_residual
    function svyglm_cons(glm, nullglm, data, weights,rtol,atol,maxiter)
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
        out.naive_cov = vcov(glm)/GLM.dispersion(glm.model,true)
        out.df_null = dof_residual(nullglm)
        out.null_deviance = deviance(nullglm)
        out.df_residual = dof_residual(glm)
        out
    end

    function svyglm(formula, design, dist=Normal(), link=canonicallink(dist))
        data = design.variables
        rtol = 1e-8
        atol = 1e-8
        maxiter = 30
        weights = 1 ./ data.probs

        glmout = glm(formula, data, dist, link, wts = weights, rtol = rtol, atol = atol, maxiter = maxiter)
        nullglm = glm(nullformula(formula), data, dist, link, wts = weights, rtol = rtol, atol = atol, maxiter = maxiter)
        svyglm_cons(glmout, nullglm, data, weights, rtol, atol, maxiter)
    end

    svyglm(;formula, design, dist=Normal(), link=canonicallink(dist)) = svyglm(formula,design,dist,link)

end

function Base.show(io::IO, g::svyglm)
    print(g.glm)
    println("")
    println("Degrees of Freedom: $(g.df_null) (i.e. Null); $(g.df_residual) Residual")
    println("Null Deviance: $(g.null_deviance)")
    println("Residual Deviance: $(g.deviance)")
    println("AIC: $(g.aic)")
end
