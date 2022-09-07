module Survey

using DataFrames
using Statistics
using StatsBase
using CSV
using GLM
using LinearAlgebra
using CairoMakie
using AlgebraOfGraphics

include("SurveyDesign.jl")
include("svydesign.jl")
include("svymean.jl")
include("svyquantile.jl")
include("svytotal.jl")
include("load_data.jl")
include("svyglm.jl")
include("svyhist.jl")
include("svyplot.jl")
include("dimnames.jl")
include("svyboxplot.jl")
include("svyby.jl")

export load_data
export AbstractSurveyDesign, SimpleRandomSample, StratifiedSample, ClusterSample
export svydesign
export svyglm
export svyby
export dim, colnames, dimnames
export svymean, svytotal, svyquantile
export @formula
export svyplot
export svyhist, sturges, freedman_diaconis
export svyboxplot
export
    #families
    Normal,
    Binomial,
    Gamma,
    Poisson,
    #links
    IdentityLink,
    InverseLink,
    LogLink,
    LogitLink,
    ProbitLink,
    CauchitLink,
    CloglogLink,
    SqrtLink
end
