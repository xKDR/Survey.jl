# [DataFrames in Survey](@id manual)

The internal structure of a survey design is build upon
[`DataFrames`](https://dataframes.juliadata.org/stable/). In fact, the `data`
argument is the only required argument for the constructor, and it must be an
[`AbstractDataFrame`](https://dataframes.juliadata.org/stable/lib/types/#DataFrames.AbstractDataFrame).

## Data manipulation

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
  there is no such column, so it should be added in order to keep `bootweights`
  general.

- `false_cluster` - only in the case of no clustering
  
  The reasoning is the same as in the case of no stratification.

- `_sampsize` - sample sizes

- `_popsize` - population sizes
  
  These match the stratification variable:

```@repl manual_DataFrames
apistrat = load_data("apistrat");
dstrat = SurveyDesign(apistrat; strata=:stype, weights=:pw);
apistrat[:, [:stype, :_sampsize, :_popsize]]
```

- `_allprobs` - probability weights

No column was added for frequency weights because the column passed through the
`weights` argument is used by other functions, hence there is no need to add a
new column. If `weights` is not specified, then a column called `_weights` is
added.