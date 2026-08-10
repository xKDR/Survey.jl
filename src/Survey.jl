module Survey

using DataFrames
import DataFrames: rename!
using Statistics
import Statistics: std, quantile, var
using StatsBase
import StatsBase: mean, quantile, confint
using Distributions
import Distributions: ccdf
using CSV
using LinearAlgebra
using CairoMakie
using AlgebraOfGraphics
using CategoricalArrays
using Random
using Missings
using GLM
import GLM: @formula, glm

include("SurveyDesign.jl")
include("linearization.jl")
include("bootstrap.jl")
include("jackknife.jl")
include("mean.jl")
include("quantile.jl")
include("total.jl")
include("load_data.jl")
include("hist.jl")
include("plot.jl")
include("boxplot.jl")
include("show.jl")
include("ratio.jl")
include("by.jl")
include("reg.jl")
include("var.jl")
include("confint.jl")
include("svytable.jl")
include("ttest.jl")
include("trim.jl")
include("brr.jl")
include("poststratify.jl")
include("chisq.jl")

export load_data
export AbstractSurveyDesign, SurveyDesign, ReplicateDesign
export BootstrapReplicates, JackknifeReplicates, BRRReplicates
export dim, colnames, dimnames
export mean, total, quantile, std
export plot
export hist, sturges, freedman_diaconis
export boxplot
export bootweights
export ratio
export jackknifeweights, variance
export degf, var, confint
export svytable, svyttest, svychisq
export trimweights, brrweights
export poststratify, rake
export @formula, glm

end
