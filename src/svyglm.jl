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
svyglm(StatsModels.TableRegressionModel{GLM.GeneralizedLinearModel{GLM.GlmResp{Vector{Float64}, Normal{Float64}, IdentityLink}, GLM.DensePredChol{Float64, LinearAlgebra.Cholesky{Float64, Matrix{Float64}}}}, Matrix{Float64}}

ell ~ 1 + meals

Coefficients:
────────────────────────────────────────────────────────────────────────
                Coef.  Std. Error      z  Pr(>|z|)  Lower 95%  Upper 95%
────────────────────────────────────────────────────────────────────────
(Intercept)  6.86665   0.350512    19.59    <1e-84   6.17966    7.55364
meals        0.410511  0.00613985  66.86    <1e-99   0.398477   0.422545
────────────────────────────────────────────────────────────────────────, [6.866653500690286, 0.41051064115199803], 183×40 DataFrame
 Row │ Column1  cds             stype    name             sname                          snum   dname                dnum   c ⋯
     │ Int64    Int64           String1  String15         String                         Int64  String31             Int64  S ⋯
─────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │       1   1612910137588  H        San Leandro Hig  San Leandro High                 236  San Leandro Unified    637  A ⋯
   2 │       2   1612916002372  E        Garfield Elemen  Garfield Elementary              237  San Leandro Unified    637  A
   3 │       3   1612916002398  E        Jefferson Eleme  Jefferson Elementary             238  San Leandro Unified    637  A
   4 │       4   1612916002414  E        Madison (James)  Madison (James) Elementary       239  San Leandro Unified    637  A
   5 │       5   1612916002422  E        McKinley Elemen  McKinley Elementary              240  San Leandro Unified    637  A ⋯
   6 │       6   1612916002430  E        Monroe Elementa  Monroe Elementary                241  San Leandro Unified    637  A
   7 │       7   1612916002448  E        Roosevelt Eleme  Roosevelt Elementary             242  San Leandro Unified    637  A
   8 │       8   1612916002455  E        Washington Elem  Washington Elementary            243  San Leandro Unified    637  A
  ⋮  │    ⋮           ⋮            ⋮            ⋮                       ⋮                  ⋮             ⋮             ⋮      ⋱
 177 │     177  43733876047633  E        Weller (Joseph)  Weller (Joseph) Elementary      5444  Milpitas Unified       448  S ⋯
 178 │     178  43733876047641  E        Pomeroy (Marsha  Pomeroy (Marshall) Elementary   5445  Milpitas Unified       448  S
 179 │     179  43733876047666  M        Rancho Milpitas  Rancho Milpitas Junior High     5446  Milpitas Unified       448  S
 182 │     182  43733876047690  E        Burnett (Willia  Burnett (William) Elementary    5449  Milpitas Unified       448  S
 183 │     183  43733876067219  E        Zanker (Pearl)   Zanker (Pearl) Elementary       5450  Milpitas Unified       448  S
                                                                                                32 columns and 168 rows omitted, [33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373  …  33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373], 49195.421245741614, Normal{Float64}(μ=0.0, σ=1.0), 2, ell ~ 1 + meals, (ell = [22, 23, 27, 17, 27, 24, 10, 33, 36, 21  …  25, 17, 21, 26, 24, 29, 48, 13, 31, 30], meals = [19, 39, 39, 23, 43, 36, 17, 43, 48, 28  …  31, 18, 15, 41, 18, 33, 47, 23, 29, 26]), 1.0196009035970893e6, Float64[], [22.0, 23.0, 27.0, 17.0, 27.0, 24.0, 10.0, 33.0, 36.0, 21.0  …  25.0, 17.0, 21.0, 26.0, 24.0, 29.0, 48.0, 13.0, 31.0, 30.0], [14.66635568257825, 22.87656850561821, 22.87656850561821, 16.30839824718624, 24.518611070226203, 21.645036582162216, 13.845334400274252, 24.518611070226203, 26.57116427598619, 18.36095145294623  …  19.592483376402225, 14.255845041426252, 13.024313117970257, 23.697589787922205, 14.255845041426252, 20.41350465870622, 26.160653634834194, 16.30839824718624, 18.77146209409823, 17.539930170642236], [14.66635568257825, 22.87656850561821, 22.87656850561821, 16.30839824718624, 24.518611070226203, 21.645036582162216, 13.845334400274252, 24.518611070226203, 26.57116427598619, 18.36095145294623  …  19.592483376402225, 14.255845041426252, 13.024313117970257, 23.697589787922205, 14.255845041426252, 20.41350465870622, 26.160653634834194, 16.30839824718624, 18.77146209409823, 17.539930170642236], [33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373  …  33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373, 33.846996307373], [7.333644317421751, 0.12343149438179069, 4.123431494381791, 0.6916017528137601, 2.4813889297737965, 2.3549634178377836, -3.845334400274252, 8.481388929773797, 9.428835724013808, 2.6390485470537683  …  5.407516623597775, 2.7441549585737484, 7.975686882029743, 2.3024102120777954, 9.744154958573748, 8.58649534129378, 21.839346365165806, -3.30839824718624, 12.22853790590177, 12.460069829357764])
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
        out.converged = true
        out
    end

    function svyglm(formula, design, dist, link)
        data = design.data
        if design.probs != Symbol("")
            weights = (1.0 ./ data[:,design.probs])
        else
            weights = ones(size(data)[1])
        end
        if design.weights != Symbol("")
            weights .*= data[:,design.weights]
        end
        absglm = glm(formula, data, dist, link, wts = weights, rtol = 1e-8, atol = 1e-8)
        svyglm_cons(absglm, data, weights)
    end
end

function Base.show(io::IO, g::svyglm)
    print(g.glm)
end