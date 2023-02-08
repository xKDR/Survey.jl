"""
    Hartley Rao Approximation of the variance of the Horvitz-Thompson Estimator.
    Avoids exhaustively calculating joint (inclusion) probabilities πᵢⱼ of the sampling scheme. 
"""
function HartleyRao(y::AbstractVector, design::SurveyDesign, HT_total)
    πᵢ = design.data[!,design.allprobs]
    hartley_rao_var = sum((1 .- ((design.data[!,design.sampsize] .- 1) ./ design.data[!,design.sampsize]) .* πᵢ) .*
                          ((y .* design.data[!,design.weights]) .- (HT_total ./ design.data[!,design.sampsize])) .^ 2)
    return hartley_rao_var
end