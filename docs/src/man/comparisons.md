# Comparison with other survey analysis tools

There are multiple alternatives that offer survey analysis tools, most notably
[SAS](https://support.sas.com/rnd/app/stat/procedures/SurveyAnalysis.html),
[Stata](https://www.stata.com/features/survey-methods/) and
[R](https://CRAN.R-project.org/package=survey).

## R comparison

The inspiration for `Survey.jl` comes from R. Hence the syntax is in most cases
very similar to the syntax in the [`survey` package](https://cran.r-project.org/web/packages/survey/survey.pdf)
from R. To showcase this we will use the `api` datasets found in both R's
`survey` and `Survey.jl`. See the [Tutorial](@ref) section for more details about
the `api` datesets.

All examples show the R code first, followed by the Julia code.

#### Loading data

```R
> data(api)
# all `api` datasets are loaded globally
```

```julia
julia> srs = load_data("apisrs")
# only one dataset is loaded and stored in a variable
```

#### Creating a design

```R
> srs = svydesign(id=~1, data=apisrs, weights=~pw) # simple random sample
> dstrat = svydesign(id=~1, data=apistrat, strata=~stype, weights=~pw) # stratified
> clus1 = svydesign(id=~dnum, data=apiclus1, weights=~pw) # clustered (one stage)
```

```julia
julia> srs = SurveyDesign(apisrs; weights=:pw) # simple random sample
julia> dstrat = SurveyDesign(apistrat; strata=:stype, weights=:pw) # stratified
julia> clus1 = SurveyDesign(apiclus1; clusters=:dnum, weights=:pw) # clustered (one stage)
```

#### Creating a replicate design

```R
> bsrs = as.svrepdesign(srs, type="subbootstrap")
```

```julia
julia> bsrs = bootweights(srs)
```

#### Computing the estimated mean

```R
> svymean(~api00, bsrs)
> svymean(~api99+~api00, bsrs)
```

```julia
julia> mean(:api00, bsrs)
julia> mean([:api99, :api00], bsrs)
```

#### Computing the estimated total

```R
> svytotal(~api00, bsrs)
> svytotal(~api99+~api00, bsrs)
```

```julia
julia> total(:api00, bsrs)
julia> total([:api99, :api00], bsrs)
```

#### Computing quantiles

```R
> svyquantile(~api00, bsrs, 0.5)
> svyquantile(~api00, bsrs, c(0.25, 0.5, 0.75))
```

```julia
julia> quantile(:api00, bsrs, 0.5)
julia> quantile(:api00, bsrs, [0.25, 0.5, 0.75])
```

#### Domain estimation

```R
> svyby(~api00, ~cname, bsrs, svymean)
```

```julia
julia> mean(:api00, :cname, bsrs)
```

#### Linearized (Taylor) standard errors and finite population correction

Like `svydesign` objects in R, a `SurveyDesign` computes standard errors by
Taylor linearization; constructing the design with `popsize` applies a finite
population correction, like `fpc` in R.

```R
> clus1 = svydesign(id=~dnum, data=apiclus1, fpc=~fpc)
> svymean(~api00, clus1)
> svytotal(~api00, clus1)
> svyratio(~api00, ~enroll, clus1)
```

```julia
julia> clus1 = SurveyDesign(apiclus1; clusters=:dnum, popsize=:fpc)
julia> mean(:api00, clus1)
julia> total(:api00, clus1)
julia> ratio([:api00, :enroll], clus1)
```

#### Proportions of a categorical variable

```R
> svymean(~stype, clus1)
> svytotal(~stype, clus1)
```

```julia
julia> mean(:stype, clus1)
julia> total(:stype, clus1)
```

#### Population variance, degrees of freedom and confidence intervals

```R
> svyvar(~api00, clus1)
> degf(clus1)
> confint(svymean(~api00, clus1))
> confint(svymean(~api00, clus1), df=degf(clus1))
```

```julia
julia> var(:api00, clus1)
julia> degf(clus1)
julia> confint(mean(:api00, clus1))
julia> confint(mean(:api00, clus1); dof=degf(clus1))
```

#### Contingency tables and tests

```R
> svytable(~stype+awards, dstrat)
> svyttest(api00~comp.imp, dstrat)
> svychisq(~stype+awards, dstrat)
```

```julia
julia> svytable(dstrat, :stype, :awards)
julia> svyttest(:api00, Symbol("comp.imp"), dstrat)
julia> svychisq(dstrat, :stype, :awards)
```

#### Quantiles with Woodruff confidence intervals

```R
> oldsvyquantile(~api00, dstrat, 0.5, ci=TRUE, interval.type="Wald")
```

```julia
julia> quantile(:api00, dstrat, 0.5; ci=true)
```

#### Post-stratification, raking and weight trimming

```R
> pop.types = data.frame(stype=c("E","H","M"), Freq=c(4421,755,1018))
> pop.schwide = data.frame(sch.wide=c("No","Yes"), Freq=c(1072,5122))
> postStratify(clus1, ~stype, pop.types)
> rake(clus1, list(~stype,~sch.wide), list(pop.types, pop.schwide))
> trimWeights(dstrat, upper=40)
```

```julia
julia> pop_types = DataFrame(stype=["E","H","M"], Freq=[4421,755,1018])
julia> pop_schwide = DataFrame(Symbol("sch.wide")=>["No","Yes"], :Freq=>[1072,5122])
julia> poststratify(clus1, :stype, pop_types)
julia> rake(clus1, [:stype, Symbol("sch.wide")], [pop_types, pop_schwide])
julia> trimweights(dstrat; upper=40)
```

#### Balanced repeated replication (BRR) and Fay's method

```R
> scddes = svydesign(data=scd, id=~ambulance, strata=~ESA, nest=TRUE, weights=~w)
> scdbrr = as.svrepdesign(scddes, type="BRR", mse=TRUE)
> scdfay = as.svrepdesign(scddes, type="Fay", fay.rho=0.3, mse=TRUE)
```

```julia
julia> scddes = SurveyDesign(scd; clusters=:ambulance, strata=:ESA, weights=:w)
julia> scdbrr = brrweights(scddes)
julia> scdfay = brrweights(scddes; fay_rho=0.3)
```
