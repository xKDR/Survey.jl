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

"""
    Horvitz-Thompson total
"""
function ht_total(x::Symbol, design::AbstractSurveyDesign)
    X̂ₕₜ = wsum(design.data[!, x], weights(design.data[!, design.weights]))
    var = HartleyRao(x, design, X̂ₕₜ)
    DataFrame(total = X̂, var = var)
end