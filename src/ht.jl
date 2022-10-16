# TODO: add docstrings
function HorwitzThompson_HartleyRaoApproximation(y::AbstractVector, design::AbstractSurveyDesign, HT_total)
    # TODO: change function name
    # TODO: change variable name (gets mixed up with the constant pi)
    pi = design.data.probs
    hartley_rao_var = sum((1 .- ((design.sampsize .- 1) ./ design.sampsize) .* pi) .*
                          ((y .* design.data.weights) .- (HT_total ./ design.sampsize)) .^ 2)
    return sqrt(hartley_rao_var)
end

# TODO: add docstrings
function ht_calc(x::Symbol, design)
    # TODO: change function name
    total = wsum(Float32.(design.data[!, x]), design.data.weights)
    se = HorwitzThompson_HartleyRaoApproximation(design.data[!, x], design, total)
    return DataFrame(total = total, se = se)
end
