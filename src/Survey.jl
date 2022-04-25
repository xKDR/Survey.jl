module Survey

using DataFrames
using Statistics
using StatsBase
using CSV

include("svydesign.jl")
include("svyby.jl")
include("example.jl")

export svydesign, svyby
export data, api, apiclus1, apiclus2, apipop
export svymean, svytotal, svyquantile

end

