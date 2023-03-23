function raking(
    design::AbstractSurveyDesign, sample_margins_row::Symbol,
	sample_margins_col::Symbol, population_margins_row::Vector, 
    population_margins_col::Vector, 
    control = Dict("maxit" => 10, "epsilon" => 1))
	
    count = 0
	epsilon = 10000
	popsize = sum(population_margins_row)
	sampsize = length(design.data[!, sample_margins_row]) * 0.5
	gdf1 = combine(groupby(design.data, sample_margins_row), nrow)
	# @show gdf1
	gdf2 = combine(groupby(design.data, sample_margins_col), nrow)
	# @show gdf2
	b = gdf1[!, :nrow] .* (popsize ./ sampsize)
	a = gdf2.nrow .* (popsize / sampsize)
	coln = nrow(gdf1)
	rown = nrow(gdf2)
	colsum = zeros(rown)
	df = DataFrame()
	while count <= control["maxit"] || epsilon >= control["epsilon"]
		for i in 1:coln-1
			for j in 1:rown
				colsum[j] = 0
				df.i = design.data[!, sample_margins_col][i] / rown
				colsum[j] = colsum + design.data.weights[j, i]
			end
		end
		design.weights[j, ncol] = design.data[!, sample_margins_row] - colsum[j]
		count = count + 1
	end
	return DataFrame(design.data.sample_weights)
end