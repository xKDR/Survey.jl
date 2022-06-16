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
    function svyglm_cons(glm, data, weights)
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
        out
    end

    function svyglm(formula, design, dist, link)
        data = design.data
        if design.probs != Symbol("")
            weights = (1.0 ./ data[:,design.probs])
        else
            weights = ones(size(data)[1])
        end
        absglm = glm(formula, data, dist, link, wts = weights, rtol = 1e-8, atol = 1e-8)
        svyglm_cons(absglm, data, weights)
    end
end