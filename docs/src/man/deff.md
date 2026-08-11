# Design Effect (`deff`)

The **Design Effect (Deff)** is a key metric in survey sampling that quantifies how much more (or less) variable an estimate is under a complex sampling design compared to a simple random sample (SRS) of the same size.

Formally:

```math
\text{Deff} = \frac{\text{Var}_{\text{complex}}}{\text{Var}_{\text{SRS}}}
````

Where:

* `Var_complex` is the variance under the actual survey design (usually estimated via bootstrap or replication).
* `Var_SRS` is the variance assuming simple random sampling.

A `Deff` greater than 1 means that the complex design results in greater variance (less efficiency), typically due to clustering. A `Deff` less than 1 suggests gains in precision, e.g., from stratification.

---

## Usage

```julia
deff(var::Symbol, design::SurveyDesign; replicates=1000) -> Float64
deff(var::Symbol, srs::SurveyDesign, reps::ReplicateDesign) -> Float64
```

## Arguments:

* `var`: The variable to compute the design effect for.
* `design`: A [`SurveyDesign`](@ref) object representing the survey design.
* `replicates`: Number of bootstrap replicates to use (default: 1000).

Alternatively, you can pass an already computed [`ReplicateDesign`](@ref) object:

* `srs`: A [`SurveyDesign`](@ref) object representing a simple random sample design.
* `reps`: A [`ReplicateDesign`](@ref) object, e.g. produced via `bootweights(...)`.

```@example
using Survey

# Load sample dataset and construct designs
apisrs = load_data("apisrs")
srs = SurveyDesign(apisrs; weights=:pw)

# Compute Deff for api99 using the simple interface
deff(:api99, srs)

# Or use the explicit replicate design
bsrs = bootweights(srs; replicates=500)
deff(:api99, srs, bsrs)
```

## R Comparison

### Example 1: SRS

> data(api)
> srs <- svydesign(ids = ~1, weights = ~pw, data = apisrs)
> svymean(~api00, srs, deff = TRUE)
          mean       SE   DEff
api00 656.5850   9.4028 1.0334

Julia Equivalent:
```julia
apisrs = load_data("apisrs")
srs = SurveyDesign(apisrs; weights=:pw)
deff(:api00, srs)
```
#### Expected: de ≈ 1.0334 (Actual: ≈ 1.0346)

### Example 2: Clustered Design

> dclus1 <- svydesign(id = ~dnum, weights = ~pw, data = apiclus1, fpc = ~fpc)
> svymean(~api00, dclus1, deff = TRUE)
         mean      SE   DEff
api00 644.169  23.542 9.3459

Julia Equivalent:
```julia
apiclus1 = load_data("apiclus1")
dclus1 = SurveyDesign(apiclus1; clusters=:dnum, weights=:pw)
deff(:api00, dclus1)
```
#### Expected: de ≈ 9.3459 (Actual: ≈ 9.4428)

## Tests

Unit tests are defined in test/deff.jl:
```julia
@testset "Design Effect" begin
    d = deff(:api99, srs, bsrs)
    @test d > 0.5 && d < 3.0
end

@testset "Different Replicates" begin
    d2 = deff(:api99, srs, bootweights(srs; replicates=500))
    d_ref = deff(:api99, srs, bsrs)
    @test abs(d2 - d_ref) > 1e-3
end

@testset "Different Weights" begin
    apisrs_alt = deepcopy(apisrs)
    apisrs_alt[!, :pw_alt] .= apisrs_alt.pw .* (1 .+ 0.1 .* randn(length(apisrs_alt.pw)))
    srs_alt = SurveyDesign(apisrs_alt; weights=:pw_alt)
    d_alt = deff(:api99, srs_alt, bootweights(srs_alt; replicates=1000))
    d_ref = deff(:api99, srs, bsrs)
    @test abs(d_alt - d_ref) > 1e-3
end

@testset "Different Variables" begin
    d_api00 = deff(:api00, srs, bsrs)
    d_api99 = deff(:api99, srs, bsrs)
    @test abs(d_api00 - d_api99) > 1e-3
end
```

## Interpretation

If:

* `Deff ≈ 1`: Your sampling design behaves like an SRS.
* `Deff > 1`: Loss of precision due to clustering or unequal weights.
* `Deff < 1`: Gain in precision due to stratification or post-stratification.

## References

* Lohr, S. (2010). *Sampling: Design and Analysis*, 2nd Ed., Section 7.5.
* Rust, K. F., & Rao, J. N. K. (1996). [Variance estimation for complex surveys using replication techniques](https://journals.sagepub.com/doi/abs/10.1177/096228029600500305). *Statistical Methods in Medical Research*, 5(3), 283–310.
* PracTools : https://cran.r-project.org/web/packages/PracTools/vignettes/Design-effects.html