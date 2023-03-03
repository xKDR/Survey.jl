"""
    SummaryStats

Supertype for every type of summary statistic. 

"""

abstract type SummaryStats end

"""
    Calculate confidence intervals for given estimates.

"""

function confint(estimate::Float64, std_dev::Float64; type::String="normal", alpha::Float64=0.05)
    # Parse type of CI & calculate critical value
    if type == "normal"
        critical_value = quantile(Normal(), 1 - alpha / 2)
    end
    # Calculate upper and lower estimates
    lower = estimate .- critical_value .* std_dev
    upper = estimate .+ critical_value .* std_dev
    return (lower=lower, upper=upper)
end

"""

    Mean <: SummaryStats

Population mean estimate for a column of a SurveyDesign object.

# Arguments:
- `x::Symbol`: the column to compute population mean statistics for.
- `design::SurveyDesign`: a SurveyDesign object.

```jldoctest
julia> using Survey;
julia> apiclus1 = load_data("apiclus1");
julia> dclus1 = SurveyDesign(apiclus1; clusters=:dnum, strata=:stype, weights=:pw);

julia> api00_mean = Mean(:api00, dclus1)
(x = :api00, estimate = 644.1693989071047, std_dev = 105.74886663549471)

julia> api00_mean.estimate
644.1693989071047

julia> api00_mean.std_dev
105.74886663549471

julia> api00_mean.CI
(lower = 436.90542889560527, upper = 851.4333689186041)

```

# TODO add :
#std_err = stderror(design, x)              # standard error of the estimate of the mean

"""

struct Mean <: SummaryStats
    x::Symbol
    design::SurveyDesign
end

function Mean(x::Symbol, design::SurveyDesign)
    column = design.data[!, x]
    estimate = mean(column, weights(design.data[!, design.weights]))
    std_dev = std(column)
    CI = confint(estimate, std_dev)
    return (x=column, estimate=estimate, std_dev=std_dev, CI=CI)
end