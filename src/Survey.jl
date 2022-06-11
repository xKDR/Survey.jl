module Survey

using DataFrames
using Statistics
using StatsBase
using CSV
using GLM

include("svydesign.jl")
include("svyby.jl")
include("example.jl")
include("svyglm.jl")

export svydesign, svyby, svyglm
export data, api, apiclus1, apiclus2, apipop, apistrat, apisrs
export svymean, svytotal, svyquantile

end

