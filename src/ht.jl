"""
     Hartley Rao Approximation of the variance of the Horvitz-Thompson Estimator.
     Avoids exhaustively calculating joint (inclusion) probabilities πᵢⱼ of the sampling scheme. 
 """
function HartleyRao(x::Symbol, design::SurveyDesign, HT_total)
    y = design.data[!,x]
    πᵢ = design.data[!,design.allprobs]
    hartley_rao_var = sum((1 .- ((design.data[!,design.sampsize] .- 1) ./ design.data[!,design.sampsize]) .* πᵢ) .*
                        ((y .* design.data[!,design.weights]) .- (HT_total ./ design.data[!,design.sampsize])) .^ 2)
    return hartley_rao_var
end

"""
    HorvitzThompsonTotal(x, design)

Horvitz-Thompson total
"""
function HorvitzThompsonTotal(x::Symbol, design::SurveyDesign)
    X̂ₕₜ = wsum(design.data[!, x], weights(design.data[!, design.weights]))
    var = HartleyRao(x, design, X̂ₕₜ)
    DataFrame(total = X̂ₕₜ, var = var)
end

function HorvitzThompsonTotal(x::Vector{Symbol}, design::SurveyDesign)
    df = reduce(vcat, [HorvitzThompsonTotal(i, design) for i in x])
    insertcols!(df, 1, :names => String.(x))
    return df
end