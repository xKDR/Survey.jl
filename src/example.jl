""" The Academic Performance Index is computed for all California schools based on standardised testing of students. The data sets contain information for all schools with at least 100 students and for various probability samples of the data. 

The ```data(api)``` function loads 3 dataframes: apiclus1, apiclus2, apipop.

Details about the columns of the dataset can be found here: https://r-survey.r-forge.r-project.org/survey/html/api.html

The API program has been discontinued at the end of 2018. Information is archived at https:
//www.cde.ca.gov/re/pr/api.asp
"""

struct API
    filenames
end

api = API(["apiclus1", "apiclus2", "apipop"])

function data(dataset::API)
    package_path = pathof(Survey)
    path_len = length(package_path)
    assets_path = package_path[1:path_len-14] * "/assets"
    apiclus1_path = assets_path * "/apiclus1.csv"
    global apiclus1 = CSV.read(apiclus1_path, DataFrame)  
    apiclus2_path = assets_path * "/apiclus2.csv"
    global apiclus2 = CSV.read(apiclus2_path, DataFrame) 
    apipop_path = assets_path * "/apipop.csv"
    global apipop = CSV.read(apipop_path, DataFrame) 
    apistrat_path = assets_path * "/apistrat.csv"
    global apistrat = CSV.read(apistrat_path, DataFrame)   
    apisrs_path = assets_path * "/apisrs.csv"
    global apisrs = CSV.read(apisrs_path, DataFrame)
    return apiclus1, apiclus2, apipop, apistrat, apisrs
end