module Survey

using DataFrames
using Statistics
using StatsBase
using CSV
using GLM
using LinearAlgebra
using CairoMakie

include("svydesign.jl")
include("svyby.jl")
include("example.jl")
include("svyglm.jl")
include("svyhist.jl")
include("svyplot.jl")

export svydesign, svyby, svyglm
export data, api, apiclus1, apiclus2, apipop, apistrat, apisrs
export svymean, svytotal, svyquantile
export @formula
export svyhist, sturges, freedman_diaconis
export svyplot
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
