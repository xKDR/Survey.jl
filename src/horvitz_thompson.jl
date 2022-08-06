using Statistics, StatsBase, DataFrames
using Survey

data(api)

# Horvitz Thompson Estimator
function hte_se(y, wts)
try
	n=length(y)
	pi = 1.0 ./ wts
	
	prob = 1 .- ((1 .- pi ) .^ (1/n))

	first_sum = sum((1 .- pi) ./ (pi .^ 2) .* (y .^ 2))
	second_sum = 0
	pimat = zeros(length(pi),length(pi))
	coefmat=zeros(length(pi),length(pi))
	for i in 1:length(pi)
		for j in 1:length(pi)
			if i != j
				pimat[i,j] = pi[i] + pi[j] - (1 - ((1 - prob[i] - prob[j] ) ^ n))
				coefmat[i,j] = ((pimat[i,j] - ( pi[i] * pi[j]) ) / (pi[i] * pi[j] * pimat[i,j]))
				second_sum += coefmat[i,j] * y[i] * y[j]
			end
		end
	end
	
	return sqrt(abs(first_sum + second_sum))
catch
	return -1
end

end

ds = select(apiclus1, [:cname, :api00, :pw])
gd = groupby(ds, :cname)

y = gd[2].api00
w = gd[2].pw

combine(gd, [:api00, :pw] => ((x, w) -> hte_se(x, w)) => :se)

