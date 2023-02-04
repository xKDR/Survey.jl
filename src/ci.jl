"""
    Calculate confidence intervals for given estimates.
    Supports normal, margin of error and t-distribution based CI.
"""
function _ci(df::DataFrame, type::String="normal"; alpha::Float64=0.05, dof::Float64=Inf64, margin::Float64=2.0)
    estimate = select(df,1) # est should be in first column
    se = select(df,2) # se should be in second column
    # Parse type of CI, calc critical value
    if type == "normal"
        critical_value = quantile(Normal(),1-alpha/2)
    elseif type == "margin"
        critical_value = margin
    elseif type == "t"
        critical_value = quantile(TDist(dof),1-alpha/2)
    end
    # Calculate upper and lower estimates
    ci_lower = estimate .- critical_value .* se
    ci_upper = estimate .+ critical_value .* se
    return ci_lower, ci_upper
end