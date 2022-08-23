"""
Supertype for every survey design type: `SimpleRandomSample`, `ClusterSample`
and `StratifiedSample`.
"""
abstract type SurveyDesign end

"""
A `SimpleRandomSample` object contains survey design information needed to
analyse surveys sampled by simple random sampling.
TODO: documentation about user making a copy
TODO: add fpc
"""
struct SimpleRandomSample <: SurveyDesign
    data::DataFrame
    function SimpleRandomSample(data::DataFrame; weights = ones(nrow(data)), probs = 1 ./ weights)
        # add frequency weights, probability weights and sample size columns
        data[!, :weights] = weights
        data[!, :probs] = probs
        data[!, :sampsize] = repeat([nrow(data)], nrow(data))

        new(data)
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
