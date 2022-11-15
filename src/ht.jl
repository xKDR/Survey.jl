# TODO: improve docstrings?
"""
    Hartley Rao Approximation of the variance of the Horvitz-Thompson Estimator.
    Avoids exhaustively calculating joint (inclusion) probabilities πᵢⱼ of the sampling scheme. 
"""
function HT_HartleyRaoVarApprox(y::AbstractVector, design::AbstractSurveyDesign, HT_total)
    # TODO: change function name
    πᵢ = design.data.probs
    hartley_rao_var = sum((1 .- ((design.sampsize .- 1) ./ design.sampsize) .* πᵢ) .*
                          ((y .* design.data.weights) .- (HT_total ./ design.sampsize)) .^ 2)
    return hartley_rao_var
end

"""
    Horvitz-Thompson Estimator of Population Total
    For arbitrary sampling probabilities
"""
function ht_svytotal(x::Symbol, design)
    total = wsum(Float32.(design.data[!, x]), design.data.weights)
    var_total = HT_HartleyRaoVarApprox(design.data[!, x], design, total)
    return DataFrame(total = total, se = sqrt(var_total))
end

# TODO: add docstrings
"""
    Horvitz-Thompson Estimator of Population Mean
    Scales the Population Total by the relevant
"""
function ht_svymean(x::Symbol, design)
    total_df = ht_svytotal(x, design)
    total = total_df.total[1]
    var_total = total_df.se[1]
    mean = 1.0 ./ sum(design.popsize) .* total
    # TODO check standard error, it is incorrect?
    # @show total_df, total, var_total, mean
    #1.0 ./ (sum(design.popsize).^2) .* 
    # @show design.popsize
    se = sqrt( var_total )
    return DataFrame(mean = mean, se = se)
end