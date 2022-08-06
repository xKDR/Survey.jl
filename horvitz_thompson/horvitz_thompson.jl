using Statistics, StatsBase, DataFrames
using Survey

data(api)

# Horvitz Thompson Estimator
myround(x) = trunc(x,sigdigits=3)
function hte(y, wts, n)
	pi = 1.0 ./ wts
	prob = 1 .- ((1 .- pi) .^ (1/n))

	first_sum = sum((1 .- pi) ./ (pi .^ 2) .* (y .^ 2))
	second_sum = 0
	pimat = zeros(length(pi),length(pi))
	coefmat=zeros(length(pi),length(pi))
	for i in 1:length(pi)
		for j in 1:length(pi)
			if i != j
				pimat[i,j] = pi[i] + pi[j] - (1 - ((1 - prob[i] - prob[j]) ^ n))
				coefmat[i,j] = ((pimat[i,j] - ( pi[i] * pi[j]) ) / (pi[i] * pi[j] * pimat[i,j]))
				second_sum += coefmat[i,j] * y[i] * y[j]
			end
		end
	end
	
	return first_sum + second_sum
end

function hte_se(y, pw, n)
	return sqrt(abs(hte(y, pw, n)))
	#return abs(hte(y, pw, n))
end


ds = select(apiclus1, [:cname, :api00, :pw])
gd = groupby(ds, :cname)

# hte(apiclus1.api00, apiclus1.pw, length(apiclus1.api00))
y = gd[2].api00
w = gd[2].pw
n = length(y)

hte(y, w, n)
hte_se(y, w, n)
function dostuff()
combine(gd, [:api00, :pw] => ((x, w) -> hte_se(x, w, length(x))) => :se)
end
