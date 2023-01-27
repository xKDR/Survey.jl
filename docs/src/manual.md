# Manual

## DataFrames in Survey

The internal structure of a survey design is build upon
[`DataFrames`](https://dataframes.juliadata.org/stable/). In fact, the `data`
argument is the only required argument for the constructor and it must be an
[`AbstractDataFrame`](https://dataframes.juliadata.org/stable/lib/types/#DataFrames.AbstractDataFrame).

### Data manipulation

The provided `DataFrame` is altered by the [`SurveyDesign`](@ref) constructor
in order to add columns for frequency and probability weights, sample and
population sizes and, if necessary, strata and cluster information.

Notice the change in `apisrs`:

```@setup manual_DataFrames
using Survey
```

```@repl manual_DataFrames
apisrs = load_data("apisrs")
names(apisrs)
srs = SurveyDesign(apisrs; weights=:pw);
apisrs
names(apisrs)
```

Five columns were added:

- `false_strata` - only in the case of no stratification
  
  This column is necessary because when making a [`ReplicateDesign`](@ref), the
  [`bootweights`](@ref) function uses [`groupby`](https://dataframes.juliadata.org/stable/lib/functions/#DataFrames.groupby)
  with a column representing the stratification variable. If there are no strata,
  there is no such column so it should be added in order to keep `bootweights`
  general.

- `false_cluster` - only in the case of no clustering
  
  The reasoning is the same as in the case of no stratification.

- `_sampsize` - sample sizes

- `_popsize` - population sizes
  
  These match the stratification variable:

```@repl manual_DataFrames
apistrat = load_data("apistrat");
strat = SurveyDesign(apistrat; strata=:stype, weights=:pw);
apistrat[:, [:stype, :_sampsize, :_popsize]]
```

- `_allprobs` - probability weights

No column was added for frequency weights because the column passed through the
`weights` argument is used by other functions, hence there is no need to add a
new column. If `weights` is not specified, then a column called `_weights` is
added.

### Why DataFrames

Survey data most of the time, if not always, is structured in a way that is very
well suited for data frames. The [`DataFrames.jl`](https://dataframes.juliadata.org/stable/)
package is mature and well maintained and provides a lot of functionality that
proves useful for using inside functions such as [`bootweights`](@ref) or
[`mean`](@ref). Mainly, the functions used are
[`groupby`](https://dataframes.juliadata.org/stable/lib/functions/#DataFrames.groupby)
and [`combine`](https://dataframes.juliadata.org/stable/lib/functions/#DataFrames.combine).

Now that support for [metadata](https://dataframes.juliadata.org/stable/lib/metadata/)
was introduced in `DataFrames.jl`, it becomes possible to use metadata in
`Survey.jl` to reduce space complexity. For example, stratification and clustering
information could be stored as metadata of the `DataFrame` passed through `data`.

## ReplicateDesign

## Plotting

`Survey` uses [`AlgebraOfGraphics`](https://aog.makie.org/stable/) for plotting.
All plotting functions support a variable number of keyword arguments (through
`kwargs...`) that are passed internally to corresponding `AlgebraOfGraphics`
functions. See the source code for details:
[`plot`](https://github.com/xKDR/Survey.jl/blob/main/src/plot.jl),
[`hist`](https://github.com/xKDR/Survey.jl/blob/main/src/hist.jl),
[`boxplot`](https://github.com/xKDR/Survey.jl/blob/main/src/boxplot.jl).
This means that all functionality provided by `AlgebraOfGraphics` is supported
in `Survey`.

Specific functionality might need to be imported from `AlgebraOfGraphics`.
Moreover, in order to choose the preferred
[`Makie backend`](https://docs.makie.org/stable/#makie_ecosystem) you must
explicitly use it:

```@repl
using AlgebraOfGraphics, CairoMakie
```

## Comparison with other languages

There are multiple languages that offer survey analysis tools, most notably
[SAS/STAT](https://support.sas.com/rnd/app/stat/procedures/SurveyAnalysis.html)
and [R](https://CRAN.R-project.org/package=survey).

### R comparison

The inspiration for `Survey.jl` comes from R. Hence the syntax is in most cases
very similar to the syntax in the [`survey` package](https://cran.r-project.org/web/packages/survey/survey.pdf)
from R. To showcase this we will use the `apisrs` dataset found in both R's
`survey` and `Survey.jl`. See the [Tutorial](@ref) section for more details about
the `api` datesets.

All examples show the R code first, followed by the Julia code.

#### Loading data

```R
data(api)
# all `api` datasets are loaded globally
```

```julia
srs = load_data("apisrs")
# only one dataset is loaded and stored in a variable
```

#### Creating a design

```R
srs = svydesign(id=~1, data=apisrs, weights=~pw) # simple random sample
strat = svydesign(id=~1, data=apistrat, strata=~stype, weights=~pw) # stratified
clus1 = svydesign(id=~dnum, data=apiclus1, weights=~pw) # clustered (one stage)
```

```julia
srs = SurveyDesign(apisrs; weights=:pw) # simple random sample
strat = SurveyDesign(apistrat; strata=:stype, weights=:pw) # stratified
clus1 = SurveyDesign(apiclus1; clusters=:dnum, weights=:pw) # clustered (one stage)
```

#### Creating a replicate design

```R
bsrs = as.svrepdesign(srs, type="bootstrap")
```

```julia
bsrs = bootweights(srs)
```

#### Computing the estimated mean

```R
svymean(~api00, bsrs)
svymean(~api99+~api00, bsrs)
```

```julia
mean(:api00, bsrs)
mean([:api99, :api00], bsrs)
```

#### Computing the estimated total

```R
svytotal(~api00, bsrs)
svytotal(~api99+~api00, bsrs)
```

```julia
total(:api00, bsrs)
total([:api99, :api00], bsrs)
```

#### Computing quantiles

```R
svyquantile(~api00, bsrs, 0.5)
svyquantile(~api00, bsrs, c(0.25, 0.5, 0.75))
```

```julia
quantile(:api00, bsrs, 0.5)
quantile(:api00, bsrs, [0.25, 0.5, 0.75])
```

#### Domain estimation

```R
svyby(~api00, ~cname, bsrs, svymean)
```

```julia
mean(:api00, :cname, bsrs)
```

## Future plans
