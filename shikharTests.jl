## Shikhar added test 24.08.22
using Revise;
using Survey;
apisrs = load_data("apisrs");
srs = SimpleRandomSample(apisrs, weights = apisrs.pw );
svymean(:enroll, srs)

# Test without fpc
using Revise;
using Survey;
apisrs_nofpc = load_data("apisrs");
srs = SimpleRandomSample(apisrs_nofpc,weights = apisrs.pw,ignorefpc = true);
svytotal(:enroll, srs)

using Revise;
using Survey;
using DataFrames;
apisrs = load_data("apisrs");
srs = SimpleRandomSample(apisrs, weights = apisrs.pw );
svytotal(:enroll, srs)

srs_design = SimpleRandomSample(apisrs, weights = apisrs.pw );
factor_variable_test = svytotal(:stype, srs)

##########
using Survey
srs_design = SimpleRandomSample(apisrs, weights = apisrs.pw )


macro svypipe(design::AbstractSurveyDesign, args...)
    # Some definitions
end
@svypipe design |> groupby(:country) |> mean(:height)

using StatsBase
combine(groupby(x, :country) , :height => mean)

# Works
@pipe x  |> groupby(_, :country) |> combine(_, :height => mean)
#doesnt work
@pipe x  |> groupby(:country) |> combine(_, :height => mean)

using Lazy
import DataFrames.groupby
@> x groupby(:country) combine(:height => mean)




### Test svyby
svyby(:api00,:cname, srs, svymean )
groupby(apisrs,:cname) 
combine(groupby(apisrs,:cname) , :api00 => mean)    
combine(groupby(apisrs,:cname) , :api00 => svymean => AsTable)    




x = DataFrame(country = [1,2,3,4,4], height = [10,20,30,40,20])

svyby(srs_desing, [enroll,] , summarise = mean, col = col1)

(srs_design, enroll)

# function |> (design::AbstractSurveyDesign ; func)
#     design.data |> func(...)
# end



### 5.09.22 Cleaned up tests
using Revise;
using Survey;
apisrs = load_data("apisrs");
srs = SimpleRandomSample(apisrs, weights = apisrs.pw );
svymean(:enroll, srs)


# New issue:
# Add CategoricalArrays ("Factor") support, multiple dispatch
# Add multiple dispatch methods for `CategoricalArray` type columns in the dataset
    
# • Intelligent parsing of `StringX` columns to be read as CategoricalArrays.
#     Eg/ if nunique(col) < len(col)/2

            # # If sampling probabilities given then sampling weights is inverse of probs
        # if !isnothing(probs)
        #     weights = 1 ./ probs
        # end


    # sampsize::Union{Nothing,Vector{<:Real}}
    # popsize::Union{Nothing,Vector{<:Real}}
    # sampfraction::Vector{<:Real}
    # fpc::Vector{<:Real}
        # combine(gdf) do sdf
        #     DataFrame(mean = mean(sdf[!, x], sem = sem(x, design::SimpleRandomSample)))
        # end

    # if isa(x,Symbol) && 
    #     return DataFrame(mean = ["Yolo"], sem = ["Yolo"])