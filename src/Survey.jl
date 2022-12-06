module Survey

using DataFrames
using Statistics
using StatsBase
import StatsBase: mean,quantile
using CSV
using LinearAlgebra
using CairoMakie
using AlgebraOfGraphics
using CategoricalArrays

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

export load_data
export AbstractSurveyDesign, SimpleRandomSample, StratifiedSample
export SurveyDesign
export by
export ht_calc
export dim, colnames, dimnames
export mean, total, quantile
export plot
export hist, sturges, freedman_diaconis
export boxplot
export ht_total, ht_mean

end