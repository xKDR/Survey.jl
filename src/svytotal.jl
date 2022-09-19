"""
    svytotal(x, design)

Estimate the population total for the variable specified by `x`.

```jldoctest
julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs);

julia> svytotal(:enroll, srs)
1×2 DataFrame
 Row │ total     se_total
     │ Float64   Float64
─────┼────────────────────
   1 │ 116922.0   5564.24
```
"""
function var_of_total(x::Symbol, design::SimpleRandomSample)
    return design.popsize^2 * design.fpc * var(design.data[!, x]) / design.sampsize 
end

"""
Inner method for `svyby`.
"""
function var_of_total(x::AbstractVector, design::SimpleRandomSample)
    return design.popsize^2 * design.fpc / design.sampsize * var(x)
end

function se_tot(x::Symbol, design::SimpleRandomSample)
    return sqrt(var_of_total(x, design))
end

function total(x::Symbol, design::SimpleRandomSample)
    return wsum(design.data[!, x] , weights(design.data.weights)  )
end

function svytotal(x::Symbol, design::SimpleRandomSample)
    print("Yolo")
    # Support behaviour like R for CategoricalArray type data
    if isa(x,Symbol) && isa(design.data[!,x], CategoricalArray)
        print("Yolo")
        gdf = groupby(design.data, :x)
        print("Yolo")
        return combine(gdf, (:x,design) => total => :total, (:x , design) => se_tot => :se_total )
    end
    total = design.popsize * mean(design.data[!, x]) # This also returns correct answer and is more simpler to understand than wsum
    # @show("\n",total)
    # @show(sum())
    # total = wsum(design.data[!, x] , design.data.weights  )
    return DataFrame(total = total , se_total = se_tot(x, design::SimpleRandomSample))
end

# function svytotal(x::Symbol, design::svydesign)
#     # TODO
# end
