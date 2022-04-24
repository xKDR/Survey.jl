""" The Academic Performance Index is computed for all California schools based on standardised testing of students. The data sets contain information for all schools with at least 100 students and for various probability samples of the data. 

The ```load_sample_data()``` function loads this data into a dataframe called ```apiclus1```

Details about the columns of the dataset can be found here: https://r-survey.r-forge.r-project.org/survey/html/api.html
"""
function load_sample_data()
    package_path = pathof(Survey)
    path_len = length(package_path)
    assets_path = package_path[1:path_len-14] * "/assets"
    apiclus1_path = assets_path * "/clus1.csv"
    global apiclus1 = CSV.read(apiclus1_path, DataFrame)
    return apiclus1
end