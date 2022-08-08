const PKG_DIR = joinpath(pathof(Survey), "..", "..") |> normpath
asset_path(file) = joinpath(PKG_DIR, "assets", file)

"""
The Academic Performance Index is computed for all California schools based on standardised testing of students.
The data sets contain information for all schools with at least 100 students and for various probability samples of the data.

Use `load_data(name)` to load API data, with
`name ∈ ["apiclus1", "apiclus2", "apipop", "apistrat", "apisrs"]`
being the name of the dataset.

```julia
df = load_data("apiclus1")
```

Details about the columns of the dataset can be found here: https://r-survey.r-forge.r-project.org/survey/html/api.html

The API program has been discontinued at the end of 2018. Information is archived at https:
//www.cde.ca.gov/re/pr/api.asp
"""
function load_data(name)
	name = name * ".csv"
	assets_path = joinpath(PKG_DIR, "assets")
    @assert name ∈ readdir(assets_path)

    CSV.read(asset_path(name), DataFrame, missingstring="NA")
end
