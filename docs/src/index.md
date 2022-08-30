# Survey.jl

This package is the Julia implementation of the [Survey package in R](https://cran.r-project.org/web/packages/survey/index.html) developed by [Professor Thomas Lumley](https://www.stat.auckland.ac.nz/people/tlum005).

## Introduction

At [xKDR](https://xkdr.org/) we processed millions of records from household surveys using the survey package in R. This process took hours of computing time. By implementing the code in Julia, we are able to do the processing in seconds. In this package we have implemented the functions `svymean`, `svyquantile` and `svysum`. We have kept the syntax between the two packages similar so that we can easily move our existing code to the new language.

## API

```@index
```
