```@meta
CurrentModule = Survey
```

# Survey

This package is the Julia implementation of the [Survey package in R](https://cran.r-project.org/web/packages/survey/index.html) developed by [Professor Thomas Lumley](https://www.stat.auckland.ac.nz/people/tlum005). 

## The need for moving the code to Julia. 

At [xKDR](xkdr.org) we processed millions of records from household surveys using the survey package in R. This process took hours of computing time. By implementing the code Julia, we are able to do the processing in seconds. The performance comparisions using randomly generated data are in the performance section. We have implemented svymean, svyquantile and svysum function in this package. We have kept the syntax between the two packages similar so that we can easily move our existing code to the new language.

Documentation for [Survey](https://github.com/Survey.jl).

```@autodocs
Modules = [Survey]
```
