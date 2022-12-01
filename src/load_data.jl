const PKG_DIR = joinpath(pathof(Survey), "..", "..") |> normpath
asset_path(args...) = joinpath(PKG_DIR, "assets", args...)

"""
    load_data(name)

Load a sample dataset provided in the [`assets/`](https://github.com/xKDR/Survey.jl/tree/main/assets) directory a `DataFrame`.

```jldoctest
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
   7 │    2031  19647336058200  M        Northridge Midd  Northridge Middle
   8 │    1736  19647336017271  E        Glassell Park E  Glassell Park Elemen
  ⋮  │    ⋮           ⋮            ⋮            ⋮                       ⋮      ⋱
 194 │    4880  39686766042782  E        Tyler Skills El  Tyler Skills Element ⋯
 195 │     993  15636851531987  H        Desert Junior/S  Desert Junior/Senior
 196 │     969  15635291534775  H        North High       North High
 197 │    1752  19647336017446  E        Hammel Street E  Hammel Street Elemen
 198 │    4480  37683386039143  E        Audubon Element  Audubon Elementary   ⋯
 199 │    4062  36678196036222  E        Edison Elementa  Edison Elementary
 200 │    2683  24657716025621  E        Franklin Elemen  Franklin Elementary
                                                 36 columns and 185 rows omitted
```
"""
function load_data(name)
    name = name * ".csv"
    @assert name ∈ readdir(asset_path())

    CSV.read(asset_path(name), DataFrame, missingstring="NA")
end
