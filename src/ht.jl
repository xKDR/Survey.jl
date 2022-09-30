function HorwitzThompson_HartleyRaoApproximation(y::AbstractVector, design, HT_total)
    pi = design.data.probs
    hartley_rao_variance_formula = sum( (1 .- ((design.sampsize .- 1) ./ design.sampsize ) .* pi ) .* ( (y .* design.data.weights) .- (HT_total./design.sampsize) ).^2 )
    return sqrt(hartley_rao_variance_formula)
end

function ht_calc(x::Symbol,design)
    total = wsum(Float32.( design.data[!,x] ), design.data.weights )
    # se = hte_se( design.data[!,x], design ) # works
    se = HorwitzThompson_HartleyRaoApproximation( design.data[!,x], design , total) # Also works
    return DataFrame(total = total, se = se  )
end

# function HansenHurwitzEstimator()
    
# end

# function HorwitzThompson_HartleyRaoApproximation(y::Vector{Int}, design, HT_total)
#     pi = design.data.probs
#     hartley_rao_variance_formula = sum( (1 .- ((design.sampsize .- 1) ./ design.sampsize ) .* pi ) .* ( (y./pi) .- (total./design.sampsize) ).^2 )
#     return sqrt(hartley_rao_variance_formula)
# end

#     # prob = 1 .- ((1 .- pi ) .^ (1/n))
#     # For SRS only, in other design, we need to make a function
#     # pi_i = design.sampsize / design.popsize
#     # pi_j = design.sampsize / design.popsize
    
#     # Use Hartley Rao approximation to calc joint probability of selecting two units, for any sample
#     pi_ij = hartley_rao_approx() #  design.sampsize .* (design.sampsize .- 1 ) ./ ( design.popsize .* (design.popsize .- 1) )

#     first_sum = sum((1 .- pi) ./ (pi .^ 2) .* (y .^ 2))
#     @show pi, pi_ij, first_sum
#     second_sum = 0 # sum( (pi_ij - ( pi_i * pi_j) ) / (pi_i * pi_j * pi_ij) .* y[i] .* y[j] )
    
#     # pimat = zeros(length(pi),length(pi))
#     # coefmat=zeros(length(pi),length(pi))
    
#     for i in 1:length(pi)
#         for j in 1:length(pi)
#             if i != j
#                 # pimat[i,j] = pi[i] + pi[j] - (1 - ((1 - prob[i] - prob[j] ) ^ n))
#                 coefmat = ((pi_ij - ( pi_i * pi_j) ) / (pi_i * pi_j * pi_ij))
#                 second_sum += coefmat * y[i] * y[j]
#             end
#         end
#     end
    
#     return sqrt(first_sum + second_sum)
#     # catch
#     #     return -1
#     # end
# end

# function hte_se(y::AbstractVector, design::SimpleRandomSample)
#     pi = design.data.probs

#     # For SRS only, in other design, we need to make a function
#     pi_i = design.sampsize / design.popsize
#     pi_j = design.sampsize / design.popsize
#     pi_ij = design.sampsize .* (design.sampsize .- 1 ) ./ ( design.popsize .* (design.popsize .- 1) )

#     first_sum = sum((1 .- pi_i) ./ (pi_i .^ 2) .* (y .^ 2))
#     @show pi_i , pi_j, pi_ij, first_sum
    
#     second_sum = 0
#     coefmat = ((pi_ij - ( pi_i * pi_j) ) / (pi_i * pi_j * pi_ij))
#     for i in 1:length(pi)
#         for j in 1:length(pi)
#             if i != j
#                 second_sum += coefmat * y[i] * y[j]
#             end
#         end
#     end
#     @show second_sum
#     return sqrt(first_sum + second_sum)
# end



