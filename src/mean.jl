"""
```jldoctest
julia> using Survey, Random, StatsBase; 

julia> apiclus1 = load_data("apiclus1"); 

julia> dclus1 = SurveyDesign(apiclus1, :dnum, :fpc); 

julia> bclus1 = bootweights(apiclus1; replicates = 1000)

julia> mean(:api00, bclus1)
1×2 DataFrame
 Row │ mean     SE      
     │ Float64  Float64 
─────┼──────────────────
   1 │ 644.169  23.0897
```
"""
function mean(x::Symbol, design::ReplicateDesign)
    X = mean(design.data[!, x], weights(design.data.weights))
    Xt = [mean(design.data[!, x], weights(design.data.weights .* design.data[! , "replicate_"*string(i)])) for i in 1:design.replicates]
    variance = sum((Xt .- X).^2) / design.replicates
    DataFrame(mean = X, SE = sqrt(variance))
end


function mean(x::Symbol, domain::Symbol, design::ReplicateDesign)
    gdf = groupby(design.data, domain)
    nd = length(unique(design.data[!, domain]))
    X = combine(gdf, [x, :weights] => ((a, b) -> mean(a, weights(b))) => :mean)
    Xt_mat = Array{Float64, 2}(undef, (nd, design.replicates))
    for i in 1:design.replicates
        Xt_mat[:, i] = combine(gdf, [x, :weights, Symbol("replicate_"*string(i))] => ((a, b, c) -> mean(a, weights(b .* c))) => :mean).mean
    end
    ses = []
    for i in 1:nd
        filtered_dx = filter(!isnan, Xt_mat[i, :] .- X.mean[i])
        push!(ses, sqrt(sum(filtered_dx.^2) / length(filtered_dx)))
    end
    X.SE = ses
    # X.SE = sqrt.(sum((Xt_mat .- X.mean).^2 / design.replicates, dims = 2))[:,1]
    return X
end