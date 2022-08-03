"""
	dim(design)
Get the dimensions of a survey design.

```jldoctest
julia> using Survey

julia> (; apistrat) = load_data(api);

julia> dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc);

julia> dim(dstrat)
(200, 44)
```
"""
dim(design::svydesign) = size(design.variables)

"""
	colnames(design)
Get the column names of a survey design.

```jldoctest
julia> using Survey

julia> (; apistrat) = load_data(api);

julia> dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc);

julia> colnames(dstrat)
44-element Vector{String}:
 "Column1"
 "cds"
 "stype"
 "name"
 "sname"
 "snum"
 "dname"
 "dnum"
 "cname"
 "cnum"
 ⋮
 "emer"
 "enroll"
 "api.stu"
 "pw"
 "fpc"
 "probs"
 "popsize"
 "sampsize"
 "strata"
```
"""
colnames(design::svydesign) = names(design.variables)

"""
	dimnames(design)
Get the names of the rows and columns of a survey design.

```jldoctest
julia> using Survey

julia> (; apistrat) = load_data(api);

julia> dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc);

julia> dimnames(dstrat)
2-element Vector{Vector{String}}:
 ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"  …  "191", "192", "193", "194", "195", "196", "197", "198", "199", "200"]
 ["Column1", "cds", "stype", "name", "sname", "snum", "dname", "dnum", "cname", "cnum"  …  "full", "emer", "enroll", "api.stu", "pw", "fpc", "probs", "popsize", "sampsize", "strata"]
```
"""
dimnames(design::svydesign) = [string.(1:size(design.variables, 1)), names(design.variables)]
