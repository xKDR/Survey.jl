"""
Supertype for every survey design type: `SimpleRandomSample`, `ClusterSample`
and `StratifiedSample`.
"""
abstract type SurveyDesign end

"""
A `SimpleRandomSample` object contains survey design information needed to
analyse surveys sampled by simple random sampling.
"""
struct SimpleRandomSample <: SurveyDesign
    data::DataFrame
    function SimpleRandomSample(data::DataFrame; weights = ones(nrow(data)), probs = 1 ./ weights)
        # make a copy of the original data frame to not alter it
        data_copy = copy(data)
        # add frequency weights, probability weights and sample size columns
        data_copy[!, :weights] = weights
        data_copy[!, :probs] = probs
        data_copy[!, :sampsize] = repeat([nrow(data_copy)], nrow(data_copy))

        new(data_copy)
    end
end

"""
A `StratifiedSample` object holds information necessary for surveys sampled by
stratification.
"""
struct StratifiedSample <: SurveyDesign
    data::DataFrame
end

"""
A `ClusterSample` object holds information necessary for surveys sampled by
clustering.
"""
struct ClusterSample <: SurveyDesign
    data::DataFrame
end
