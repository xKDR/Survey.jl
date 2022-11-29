"""
    Ratio estimators and Subpopulation estimates.
    Domain Estimation is special case of subpopulation estimate.
"""

function ratio(x::Symbol,y::Symbol,design::AbstractSurveyDesign)
    num = design.data[!,x]
    denom = design.data[!,y]
    # fill(A,)
    # A == B

    mean = num / denom
    return DataFrame(mean = mean)
end