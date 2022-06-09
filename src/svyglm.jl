function svyglm(formula,design,dist,link)
    glm(formula,design.data,dist,link,wts=(1.0./design.prob),rtol=1e-8,atol=1e-8)
end