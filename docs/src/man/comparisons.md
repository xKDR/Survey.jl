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
