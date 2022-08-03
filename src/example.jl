"""
The Academic Performance Index is computed for all California schools based on standardised testing of students.
The data sets contain information for all schools with at least 100 students and for various probability samples of the data.

Use `load_data(api)` to load API data. 

```julia
# load all five dataframes
(; apiclus1, apiclus2, apipop, apistrat, apisrs) = load_data(api)
# load a selection of dataframes
(; apiclus1, apipop) = load_data(api)
``` 

Details about the columns of the dataset can be found here: https://r-survey.r-forge.r-project.org/survey/html/api.html

The API program has been discontinued at the end of 2018. Information is archived at https:
//www.cde.ca.gov/re/pr/api.asp
"""
struct API
    filenames
end

api = API(["apiclus1", "apiclus2", "apipop"])

const PKG_DIR = joinpath(pathof(Survey), "..", "..") |> normpath
asset_path(file) = joinpath(PKG_DIR, "assets", file)

function load_data(dataset::API)
    apiclus1 = CSV.read(asset_path("apiclus1.csv"), DataFrame, missingstring="NA")
    apiclus2 = CSV.read(asset_path("apiclus2.csv"), DataFrame, missingstring="NA")
    apipop   = CSV.read(asset_path("apipop.csv"),   DataFrame, missingstring="NA")
    apistrat = CSV.read(asset_path("apistrat.csv"), DataFrame, missingstring="NA")
    apisrs   = CSV.read(asset_path("apisrs.csv"),   DataFrame, missingstring="NA")

    (; apiclus1, apiclus2, apipop, apistrat, apisrs)
end
