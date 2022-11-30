# API

## Index

```@index
Module = [Survey]
Order = [:type, :function]
Private = false
```

```@docs
AbstractSurveyDesign
SimpleRandomSample
StratifiedSample
load_data
mean(x::Symbol, design::SimpleRandomSample)
total(x::Symbol, design::SimpleRandomSample)
quantile
by
colnames(design::AbstractSurveyDesign)
dim(design::AbstractSurveyDesign)
dimnames(design::AbstractSurveyDesign)
plot(design::AbstractSurveyDesign, x::Symbol, y::Symbol; kwargs...)
boxplot(design::AbstractSurveyDesign, x::Symbol, y::Symbol; kwargs...)
hist(design::AbstractSurveyDesign, var::Symbol,
				 bins::Union{Integer, AbstractVector} = freedman_diaconis(design, var);
				 normalization = :density,
				 kwargs...
    			)
freedman_diaconis
sturges
```
