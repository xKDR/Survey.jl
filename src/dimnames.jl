"""
	dim(design)
Get the dimensions of a `SurveyDesign`.

```jldoctest
julia> using Survey

julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs);

julia> dim(srs)
(200, 42)
```
"""
dim(design::AbstractSurveyDesign) = size(design.data)

"""
Method for `svydesign` object.

```jldoctest
julia> using Survey

julia> apistrat = load_data("apistrat");

julia> dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc);

julia> dim(dstrat)
(200, 45)
```
"""
dim(design::svydesign) = size(design.variables)

"""
	colnames(design)
Get the column names of a `SurveyDesign`.

```jldoctest
julia> using Survey

julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs);

julia> colnames(srs)
42-element Vector{String}:
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
 "avg.ed"
 "full"
 "emer"
 "enroll"
 "api.stu"
 "pw"
 "fpc"
 "weights"
 "probs"
```
"""
colnames(design::AbstractSurveyDesign) = names(design.data)

"""
Method for `svydesign` objects.

```jldoctest
julia> using Survey

julia> apistrat = load_data("apistrat");

julia> dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc);

julia> colnames(dstrat)
45-element Vector{String}:
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
 "enroll"
 "api.stu"
 "pw"
 "fpc"
 "probs"
 "weights"
 "popsize"
 "sampsize"
 "strata"
```
"""
colnames(design::svydesign) = names(design.variables)

"""
	dimnames(design)
Get the names of the rows and columns of a `SurveyDesign`.

```jldoctest
julia> using Survey

julia> apisrs = load_data("apisrs");

julia> srs = SimpleRandomSample(apisrs);

julia> dimnames(srs)
2-element Vector{Vector{String}}:
 ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"  …  "191", "192", "193", "194", "195", "196", "197", "198", "199", "200"]
 ["Column1", "cds", "stype", "name", "sname", "snum", "dname", "dnum", "cname", "cnum"  …  "grad.sch", "avg.ed", "full", "emer", "enroll", "api.stu", "pw", "fpc", "weights", "probs"]
```
"""
dimnames(design::AbstractSurveyDesign) = [string.(1:size(design.data, 1)), names(design.data)]

"""
Method for `svydesign` objects.

```jldoctest
julia> using Survey

julia> apistrat = load_data("apistrat");

julia> dstrat = svydesign(data = apistrat, id = :1, strata = :stype, weights = :pw, fpc = :fpc);

julia> dimnames(dstrat)
2-element Vector{Vector{String}}:
 ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"  …  "191", "192", "193", "194", "195", "196", "197", "198", "199", "200"]
 ["Column1", "cds", "stype", "name", "sname", "snum", "dname", "dnum", "cname", "cnum"  …  "emer", "enroll", "api.stu", "pw", "fpc", "probs", "weights", "popsize", "sampsize", "strata"]
```
"""
dimnames(design::svydesign) = [string.(1:size(design.variables, 1)), names(design.variables)]
