# Manual

## `DataFrames` in `Survey`

The internal structure of a survey design is build upon
[`DataFrames`](https://dataframes.juliadata.org/stable/). In fact, the `data`
argument is the only required argument for the constructor and it must be an
[`AbstractDataFrame`](https://dataframes.juliadata.org/stable/lib/types/#DataFrames.AbstractDataFrame).

### Data manipulation

The provided `DataFrame` is altered by the [`SurveyDesign`](@ref) constructor
in order to add columns for frequency and probability weights, sample and
population sizes and, if necessary, strata and cluster information.

Notice the change in `apisrs`:

```julia
julia> apisrs = load_data("apisrs")
200×40 DataFrame
 Row │ Column1  cds             stype    name             sname                ⋯
     │ Int64    Int64           String1  String15         String               ⋯
─────┼──────────────────────────────────────────────────────────────────────────
   1 │    1039  15739081534155  H        McFarland High   McFarland High       ⋯
   2 │    1124  19642126066716  E        Stowers (Cecil   Stowers (Cecil B.) E
   3 │    2868  30664493030640  H        Brea-Olinda Hig  Brea-Olinda High
   4 │    1273  19644516012744  E        Alameda Element  Alameda Elementary
   5 │    4926  40688096043293  E        Sunnyside Eleme  Sunnyside Elementary ⋯
   6 │    2463  19734456014278  E        Los Molinos Ele  Los Molinos Elementa
  ⋮  │    ⋮           ⋮            ⋮            ⋮                       ⋮      ⋱
 196 │     969  15635291534775  H        North High       North High
 197 │    1752  19647336017446  E        Hammel Street E  Hammel Street Elemen
 198 │    4480  37683386039143  E        Audubon Element  Audubon Elementary   ⋯
 199 │    4062  36678196036222  E        Edison Elementa  Edison Elementary
 200 │    2683  24657716025621  E        Franklin Elemen  Franklin Elementary
                                                 36 columns and 189 rows omitted

julia> names(apisrs)
40-element Vector{String}:
 "Column1"
 "cds"
 "stype"
 "name"
 "sname"
 "snum"
 "dname"
 "dnum"
 ⋮
 "avg.ed"
 "full"
 "emer"
 "enroll"
 "api.stu"
 "pw"
 "fpc"

julia> srs = SurveyDesign(apisrs; weights=:pw);

julia> apisrs
200×45 DataFrame
 Row │ Column1  cds             stype    name             sname                ⋯
     │ Int64    Int64           String1  String15         String               ⋯
─────┼──────────────────────────────────────────────────────────────────────────
   1 │    1039  15739081534155  H        McFarland High   McFarland High       ⋯
   2 │    1124  19642126066716  E        Stowers (Cecil   Stowers (Cecil B.) E
   3 │    2868  30664493030640  H        Brea-Olinda Hig  Brea-Olinda High
   4 │    1273  19644516012744  E        Alameda Element  Alameda Elementary
   5 │    4926  40688096043293  E        Sunnyside Eleme  Sunnyside Elementary ⋯
   6 │    2463  19734456014278  E        Los Molinos Ele  Los Molinos Elementa
  ⋮  │    ⋮           ⋮            ⋮            ⋮                       ⋮      ⋱
 196 │     969  15635291534775  H        North High       North High
 197 │    1752  19647336017446  E        Hammel Street E  Hammel Street Elemen
 198 │    4480  37683386039143  E        Audubon Element  Audubon Elementary   ⋯
 199 │    4062  36678196036222  E        Edison Elementa  Edison Elementary
 200 │    2683  24657716025621  E        Franklin Elemen  Franklin Elementary
                                                 41 columns and 189 rows omitted

julia> names(apisrs)
45-element Vector{String}:
 "Column1"
 "cds"
 "stype"
 "name"
 "sname"
 "snum"
 "dname"
 "dnum"
 ⋮
 "pw"
 "fpc"
 "false_strata"
 "false_cluster"
 "_sampsize"
 "_popsize"
 "_allprobs"
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

  ```julia
  julia> apistrat = load_data("apistrat");

  julia> strat = SurveyDesign(apistrat; strata=:stype, weights=:pw);

  julia> apistrat[:, [:stype, :_sampsize, :_popsize]]
  200×3 DataFrame
   Row │ stype    _sampsize  _popsize
       │ String1  Int64      Float64
  ─────┼──────────────────────────────
     1 │ E              100    4421.0
     2 │ E              100    4421.0
     3 │ E              100    4421.0
     4 │ E              100    4421.0
     5 │ E              100    4421.0
     6 │ E              100    4421.0
    ⋮  │    ⋮         ⋮         ⋮
   196 │ E              100    4421.0
   197 │ H               50     755.0
   198 │ M               50    1018.0
   199 │ E              100    4421.0
   200 │ H               50     755.0
                      189 rows omitted
  ```

- `_allprobs` - probability weights

No column was added for frequency weights because the column passed through the
`weights` argument is used by other functions, hence there is no need to add a
new column. If `weights` is not specified, then a column called `_weights` is
added.

### Why `DataFrames`

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

## Bootstrapping

## Plotting

## Performance
