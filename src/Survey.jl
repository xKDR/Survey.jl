module Survey

using DataFrames
using Statistics
using StatsBase
using CSV
using GLM
using LinearAlgebra
using CairoMakie
using AlgebraOfGraphics
using CategoricalArrays

include("SurveyDesign.jl")
include("design.jl")
include("mean.jl")
include("quantile.jl")
include("total.jl")
include("load_data.jl")
include("glm.jl")
include("hist.jl")
include("plot.jl")
include("dimnames.jl")
include("boxplot.jl")
include("by.jl")
include("ht.jl")
include("show.jl")

export load_data
export AbstractSurveyDesign, SimpleRandomSample, StratifiedSample
export SurveyDesign
export design
export glm
export by
export ht_calc
export dim, colnames, dimnames
export mean, total, quantile
export @formula
export plot
export hist, sturges, freedman_diaconis
export boxplot
export ht_total, ht_mean
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
