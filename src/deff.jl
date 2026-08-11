using Statistics
using Survey

"""
    var_srs(var::Symbol, srs::SurveyDesign)
Estimate the variance of a variable under simple random sampling (SRS).
This function assumes unweighted SRS unless weights are provided in the `SurveyDesign`.
Returns the estimated variance of the mean.
"""
function var_srs(var::Symbol, srs::SurveyDesign)
    col_data = srs.data[!, var]
    non_missing = .!ismissing.(col_data)
    x_clean = col_data[non_missing]

    n = length(x_clean)
    μ = mean(x_clean)
    squared_deviations = (x_clean .- μ).^2
    s2 = sum(squared_deviations) / (n - 1)  # Unbiased sample variance

    # Variance of the mean estimator for unweighted SRS
    return s2 / n
end

"""
    deff(var::Symbol, srs::SurveyDesign, reps::ReplicateDesign) -> Float64

Compute the **design effect (Deff)** for a given variable in a complex survey.

Deff is defined as:
    Deff = Var_actual / Var_srs

Where:
- `Var_actual` is the variance estimated from the replicate-based design (`ReplicateDesign`)
- `Var_srs` is the closed-form variance under a simple random sample (`SurveyDesign`)

# Arguments
- `var::Symbol`: The variable for which the design effect is to be calculated.
- `srs::SurveyDesign`: The base survey design assuming simple random sampling.
- `reps::ReplicateDesign`: The replicate design used to estimate actual variance.

# Returns
- `Float64`: The computed design effect.

# Example
```julia
apisrs = load_data("apisrs")
srs = SurveyDesign(apisrs; weights=:pw)
bsrs = bootweights(srs; replicates=1000)
deff(:api99, srs, bsrs)
```
"""
function deff(var::Symbol, srs::SurveyDesign, reps::ReplicateDesign)
    # Using Survey.mean to extract the standard error (SE) is efficient because it directly
    # computes the mean and associated SE from the replicate design, avoiding manual calculations.
    mean_result = Survey.mean(var, reps)
    @assert nrow(mean_result) == 1 "Expected Survey.mean(var, reps) to return exactly one row, got $(nrow(mean_result)) rows."
    se_actual = mean_result[!, :SE]
    var_actual = first(se_actual)^2

    # Variance under SRS (from AnalyticSolution branch or replicate formula)
    var_srs_val = var_srs(var, srs)
    return var_actual / var_srs_val
end

"""
    deff(var::Symbol, design::SurveyDesign; replicates=1000) -> Float64

Compute the **design effect (Deff)** for a given variable in a complex survey.

Deff is defined as:
    Deff = Var_actual / Var_srs

Where:
- `Var_actual` is the variance estimated from the actual survey design
- `Var_srs` is the variance under a simple random sample of the same size

# Arguments
- `var::Symbol`: The variable for which the design effect is to be calculated.
- `design::SurveyDesign`: The survey design.
- `replicates::Int=1000`: Number of bootstrap replicates to use for variance estimation.

# Returns
- `Float64`: The computed design effect.

# Example
```julia
apisrs = load_data("apisrs")
srs = SurveyDesign(apisrs; weights=:pw)
deff(:api00, srs)
```
"""
function deff(var::Symbol, design::SurveyDesign; replicates=1000)
    # Create bootstrap replicates for variance estimation
    bsdesign = bootweights(design; replicates=replicates)
    return deff(var, design, bsdesign)
end