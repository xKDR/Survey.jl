using DataFrames, Statistics
using Survey, StatsBase

data(api)
names(apiclus1)
select(apiclus1, :pw)
ProbabilityWeights(apiclus1[!, :pw])

ds = select(apiclus1, [:cname, :api00, :pw])
gd = groupby(ds, :cname)
combine(gd, [:api00, :pw] => ((x, w) -> mean(x, ProbabilityWeights(w))) => :mean, [:api00, :pw] => ((x, w) -> sem(x, ProbabilityWeights(w))) => :sem)
