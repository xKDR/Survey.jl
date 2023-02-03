function bydomain(x::Symbol, domain::Symbol, design::SurveyDesign, func::Function)
    gdf = groupby(design.data, domain)
    nd = length(unique(design.data[!, domain]))
    X = combine(gdf, [x, design.weights] => ((a, b) -> func(a, weights(b))) => :statistic)
    return X
end

function bydomain(x::Symbol, domain::Symbol, design::ReplicateDesign, func::Function)
    gdf = groupby(design.data, domain)
    nd = length(unique(design.data[!, domain]))
    X = combine(gdf, [x, design.weights] => ((a, b) -> func(a, weights(b))) => :statistic)
    Xt_mat = Array{Float64, 2}(undef, (nd, design.replicates))
    for i in 1:design.replicates
        Xt_mat[:, i] = combine(gdf, [x, Symbol("replicate_"*string(i))] => ((a, c) -> func(a, weights(c))) => :statistic).statistic
    end
    ses = Float64[]
    for i in 1:nd
        filtered_dx = filter(!isnan, Xt_mat[i, :] .- X.statistic[i])
        push!(ses, sqrt(sum(filtered_dx.^2) / length(filtered_dx)))
    end
    replace!(ses, NaN => 0)
    X.SE = ses
    return X
end
