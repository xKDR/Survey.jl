# API

## Index

```@index
Module = [Survey]
Order = [:type, :function]
Private = false
```
Survey data can be loaded from a `DataFrame` into a survey design object. The package currently supports simple random sample and stratified sample designs. 
```@docs
AbstractSurveyDesign
SimpleRandomSample
StratifiedSample
```

```@docs
load_data
Survey.mean(x::Symbol, design::SimpleRandomSample)
total(x::Symbol, design::SimpleRandomSample)
quantile
```

It is often required to estimate population parameters for sub-populations of interest. For example, you make have of heights of people, but you want the average height of male and female separately. 
```@docs
mean(x::Symbol, by::Symbol, design::SimpleRandomSample) 
total(x::Symbol, by::Symbol, design::SimpleRandomSample) 
```
```@docs
plot(design::AbstractSurveyDesign, x::Symbol, y::Symbol; kwargs...)
boxplot(design::AbstractSurveyDesign, x::Symbol, y::Symbol; kwargs...)
hist(design::AbstractSurveyDesign, var::Symbol,
				 bins::Union{Integer, AbstractVector} = freedman_diaconis(design, var);
				 normalization = :density,
				 kwargs...
    			)
dim(design::AbstractSurveyDesign)
dimnames(design::AbstractSurveyDesign)
colnames(design::AbstractSurveyDesign)
```
