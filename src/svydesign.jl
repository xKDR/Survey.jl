"""
The svydesign object combines a data frame and all the survey design information needed to analyse it.

```jldoctest
julia> using Survey; 

julia> data(api); 

julia> dclus1 = svydesign(id= :dnum, weights= :pw, data = apiclus1, fpc= :fpc) |> print
Survey Design:
data: 183x40 DataFrame
weights: pw
id: dnum
fpc: fpc
nest: false
check_strat: false
```
"""
struct svydesign
    id::Symbol
    probs::Symbol
    strata::Symbol
    variables::Symbol
    fpc::Symbol
    data::DataFrame
    nest::Bool
    check_strat::Bool
    weights::Symbol 
    svydesign(; data = DataFrame(), id = Symbol(), probs = Symbol(), strata = Symbol(), variables = Symbol(), fpc = Symbol(), nest = false, check_strat = false, weights = Symbol()) = new(id, probs, strata, variables, fpc, data, nest, check_strat, weights)
end

function Base.show(io::IO, design::svydesign)
    printstyled("Survey Design:\n") 
    printstyled("data: "; bold = true)
    print(size(design.data)[1], "x", size(design.data)[2], " DataFrame")
    if length(string(design.weights)) > 0 
        printstyled("\nweights: "; bold = true)
        print(design.weights)
    end
    if length(string(design.id)) > 0
        printstyled("\nid: "; bold = true)
        print(design.id)
    end
    if length(string(design.strata)) > 0
        printstyled("\nstrata: "; bold = true)
        print(design.strata)
    end
    if length(string(design.variables)) > 0
        printstyled("\nid: "; bold = true)
        print(design.variables)
    end
    if length(string(design.fpc)) > 0
        printstyled("\nfpc: "; bold = true)
        print(design.fpc)
    end
    printstyled("\nnest: "; bold = true)
    print(design.nest)
    printstyled("\ncheck_strat: "; bold = true)
    print(design.check_strat)
end