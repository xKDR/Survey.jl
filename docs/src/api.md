# API

## Index

```@index
Module = [Survey]
Order = [:type, :function]
Private = false
```

```@docs
AbstractSurveyDesign
SurveyDesign
ReplicateDesign
load_data
bootweights
mean(x::Symbol, design::ReplicateDesign)
mean(x::Symbol, domain::Symbol, design::ReplicateDesign)
total(x::Symbol, design::ReplicateDesign)
total(x::Symbol, domain::Symbol, design::ReplicateDesign)
quantile
ratio(variable_num::Symbol, variable_den::Symbol, design::SurveyDesign)
plot(design::AbstractSurveyDesign, x::Symbol, y::Symbol; kwargs...)
boxplot(design::AbstractSurveyDesign, x::Symbol, y::Symbol; kwargs...)
hist(design::AbstractSurveyDesign, var::Symbol,
				 bins::Union{Integer, AbstractVector} = freedman_diaconis(design, var);
				 normalization = :density,
				 kwargs...
    			)
```
