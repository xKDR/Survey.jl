using GLM

struct svyglm_obj
    glm::Any
    coefficients::Any
    data::Any
    weights::Any
    svyglm_obj(glm, data, weights) = new(glm, coef(glm), data, weights)
end

function svyglm(formula,design,dist,link)
    data = design.data
    if design.probs != Symbol("")
        weights = (1.0./data[:,design.probs])
    else
        weights = ones(size(data)[1])
    end
    absglm = glm(formula,data,dist,link,wts=weights,rtol=1e-8,atol=1e-8)
    svyglm_obj(absglm,data,weights)
end