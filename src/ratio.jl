"""
    ratio(numerator, denominator, design)

Estimate the ratio of the columns specified in numerator and denominator

```jldoctest
julia> apiclus1 = load_data("apiclus1");

julia> clus_one_stage = SurveyDesign(apiclus1; clusters = :dnum, weights = :pw);

julia> ratio(:api00, :enroll, clus_one_stage)
1×2 DataFrame
 Row │ Statistic  SE       
     │ Float64    Float64  
─────┼─────────────────────
   1 │   1.17182  0.151242
```
"""
function ratio(variable_num:: Symbol, variable_den:: Symbol, design::SurveyDesign)
    statistic = wsum(design.data[!,variable_num],design.data.weights)/wsum(design.data[!,variable_den],design.data.weights)
    nh = length(unique(design.data[!,design.cluster]))
    newv = []
    gdf = groupby(design.data, design.cluster)
    replicates = [filter(n -> n != i, 1:nh) for i in 1:nh] 
    for i in replicates
        df = DataFrame(gdf[i])
        push!(newv, wsum(df[!,variable_num],df[!,:weights])/wsum(df[!,variable_den],df[!,:weights]))
    end
    c = 0
    for i in 1:nh
        c = c+(newv[i]-statistic)^2
    end
    var = c*(nh-1)/nh
    return DataFrame(Statistic = statistic, SE = sqrt(var))
end
