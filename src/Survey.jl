module Survey

using DataFrames
using Statistics
import Statistics: quantile
using StatsBase
import StatsBase: mean,quantile
using CSV
using LinearAlgebra
using CairoMakie
using AlgebraOfGraphics
using CategoricalArrays
using Random

include("SurveyDesign.jl")
include("mean.jl")
include("quantile.jl")
include("total.jl")
include("load_data.jl")
include("hist.jl")
include("plot.jl")
include("dimnames.jl")
include("boxplot.jl")
include("show.jl")
include("bootstrap.jl")

export load_data
export AbstractSurveyDesign, SimpleRandomSample, StratifiedSample
export OneStageClusterSample
export dim, colnames, dimnames
export mean, total, quantile
export plot
export hist, sturges, freedman_diaconis
export boxplot
export bootstrap

end