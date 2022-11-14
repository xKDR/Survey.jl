```@meta
CurrentModule = Survey
```

# Survey

This package is the Julia implementation of the [Survey package in R](https://cran.r-project.org/web/packages/survey/index.html) developed by [Professor Thomas Lumley](https://www.stat.auckland.ac.nz/people/tlum005).

## The need for moving the code to Julia.

At [xKDR](https://xkdr.org/) we processed millions of records from household surveys using the survey package in R. This process took hours of computing time. By implementing the code in Julia, we are able to do the processing in seconds. In this package we have implemented the functions `svymean`, `svyquantile` and `svysum`. We have kept the syntax between the two packages similar so that we can easily move our existing code to the new language.

## Index

```@index
Module = [Survey]
Order = [:type, :function]
Private = false
```

## API
```@docs
AbstractSurveyDesign
SimpleRandomSample
StratifiedSample
ClusterSample
svydesign
svyglm
load_data
svymean(x::Symbol, design::SimpleRandomSample)
svytotal(x::Symbol, design::SimpleRandomSample)
svyquantile
svyby
colnames(design::AbstractSurveyDesign)
dim(design::AbstractSurveyDesign)
dimnames(design::AbstractSurveyDesign)
svyplot(design::AbstractSurveyDesign, x::Symbol, y::Symbol; kwargs...)
svyboxplot(design::AbstractSurveyDesign, x::Symbol, y::Symbol; kwargs...)
svyhist(design::AbstractSurveyDesign, var::Symbol,
				 bins::Union{Integer, AbstractVector} = freedman_diaconis(design, var);
				 normalization = :density,
				 kwargs...
    			)
freedman_diaconis
sturges
```
