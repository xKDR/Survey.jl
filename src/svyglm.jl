function svyglm(formula,design,dist,link)
    data = design.data
    weights = (1.0./data[:,design.probs])
    glm(formula,data,dist,link,wts=weights,rtol=1e-8,atol=1e-8)
end