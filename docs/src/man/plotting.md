# Plotting

`Survey` uses [`AlgebraOfGraphics`](https://aog.makie.org/stable/) for plotting.
All plotting functions support a variable number of keyword arguments (through
`kwargs...`) that are passed internally to corresponding `AlgebraOfGraphics`
functions. See the source code for details:
[`plot`](https://github.com/xKDR/Survey.jl/blob/main/src/plot.jl),
[`hist`](https://github.com/xKDR/Survey.jl/blob/main/src/hist.jl),
[`boxplot`](https://github.com/xKDR/Survey.jl/blob/main/src/boxplot.jl).
This means that all functionality provided by `AlgebraOfGraphics` is supported
in `Survey`.

Specific functionality might need to be imported from `AlgebraOfGraphics`.
Moreover, in order to choose the preferred
[`Makie backend`](https://docs.makie.org/stable/#makie_ecosystem) you must
explicitly use it:

```julia
using AlgebraOfGraphics, CairoMakie
```
