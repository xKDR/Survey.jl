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
using Missings

include("SurveyDesign.jl")
include("bootstrap.jl")
include("mean.jl")
include("quantile.jl")
include("jackknife.jl")
include("total.jl")
include("load_data.jl")
include("hist.jl")
include("plot.jl")
include("boxplot.jl")
include("show.jl")
include("ratio.jl")
include("by.jl")

export load_data
export AbstractSurveyDesign, SimpleRandomSample, StratifiedSample
export SurveyDesign
export dim, colnames, dimnames
export mean, total, quantile
export plot
export hist
export boxplot
export bootweights
export jkknife
export ratio

end