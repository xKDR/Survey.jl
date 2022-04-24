module Survey

using DataFrames
using Statistics
using StatsBase
using CSV

include("svydesign.jl")
include("svyby.jl")
include("example.jl")

export svydesign
export svyby
export load_sample_data
export apiclus1

# unstack(mean_income, :HR, :statistic)

end

