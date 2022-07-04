using Statistics, StatsBase, DataFrames
using Survey

data(api)
ds = select(apiclus1, [:cname, :api00, :pw])
gd = groupby(ds, :cname)

# Horvitz Thompson Estimator
function hte(y, pw, n)
	p = 1 .- (1 .- 1 ./ pw) .^ n

	first_sum = sum((1 .- p) ./ (p .^ 2) .* y .^ 2)
	second_sum = 0

	for i in 1:length(p)
		for j in 1:length(p)
			if i == j
				continue
			end


			p_ij = p[i] + p[j] - (1 - (1 - 1 / pw[i] - 1 / pw[j]) ^ n)
			second_sum += (p_ij - p[i] * p[j]) / (p[i] * p[j]) * y[i] * y[j]
		end
	end

	return first_sum + second_sum
end

function hte_se(y, pw, n)
	return sqrt(abs(hte(y, pw, n)))
end

# hte(apiclus1.api00, apiclus1.pw, length(apiclus1.api00))
y = gd[2].api00
w = gd[2].pw
n = length(y)

hte(y, w, n)
hte_se(y, w, n)

combine(gd, [:api00, :pw] => ((x, w) -> hte_se(x, w, length(x))) => :se)
