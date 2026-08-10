"""
    brrweights(design; fay_rho = 0.0, hadamard_matrix = nothing)

Create replicate weights by balanced repeated replication (BRR), optionally with
Fay's adjustment, matching `as.svrepdesign(design, type = "BRR")` (or
`type = "Fay"`) in the R `survey` package.

Every stratum must contain exactly two PSUs. For each replicate, one PSU per
stratum is selected according to a column of a Hadamard matrix; observations in
the selected PSU have their weights multiplied by ``2 - \\rho`` and the others by
``\\rho`` (``\\rho = 0`` for standard BRR). Variances are estimated as

```math
\\hat{V}(\\hat{\\theta}) = \\dfrac{1}{R(1-\\rho)^2}\\sum_{r=1}^R (\\hat{\\theta}_r - \\hat{\\theta})^2
```

which matches R with `mse = TRUE`.

By default a Sylvester-constructed Hadamard matrix is used, of order equal to the
smallest power of two that is at least the number of strata plus one. This
matches R's `hadamard()` whenever that order is also R's choice (e.g. 3 or 7
strata); for other stratum counts R may pick a smaller non-power-of-two order, in
which case you can pass R's matrix via `hadamard_matrix` (entries may be 0/1 or
±1) to reproduce R exactly.

```jldoctest; setup = :(using Survey)
julia> scd = load_data("scd");

julia> scd.w = fill(1.0, 6);

julia> dscd = SurveyDesign(scd; clusters=:ambulance, strata=:ESA, weights=:w);

julia> bscd = brrweights(dscd)
ReplicateDesign{BRRReplicates}:
data: 6×13 DataFrame
strata: ESA
    [1, 1, 2  …  3]
cluster: ambulance
    [1, 2, 1  …  2]
popsize: [2.0, 2.0, 2.0  …  2.0]
sampsize: [2, 2, 2  …  2]
weights: [1.0, 1.0, 1.0  …  1.0]
allprobs: [1.0, 1.0, 1.0  …  1.0]
type: brr
replicates: 4
```
"""
function brrweights(
    design::SurveyDesign;
    fay_rho::Real = 0.0,
    hadamard_matrix::Union{Nothing,AbstractMatrix} = nothing,
)
    0 <= fay_rho < 1 || throw(ArgumentError("fay_rho must be in [0, 1)"))
    df = design.data
    strata_groups = _group_indices(df[!, design.strata])
    nstrata = length(strata_groups)
    # PSUs within each stratum in order of first appearance; strata are processed
    # in order of their (string) name, as in R
    stratum_names = [string(df[rows[1], design.strata]) for rows in strata_groups]
    order = sortperm(stratum_names)
    psu_rows = Vector{Tuple{Vector{Int},Vector{Int}}}(undef, nstrata)
    for (k, rows) in enumerate(strata_groups)
        psus = _group_indices(view(df[!, design.cluster], rows))
        length(psus) == 2 ||
            throw(ArgumentError("BRR requires exactly 2 PSUs in every stratum"))
        psu_rows[k] = (rows[psus[1]], rows[psus[2]])
    end
    H = isnothing(hadamard_matrix) ? _sylvester_hadamard(nstrata + 1) :
        _normalize_hadamard(hadamard_matrix)
    size(H, 1) >= nstrata + 1 ||
        throw(ArgumentError("hadamard_matrix must have dimension at least nstrata + 1"))
    replicates = size(H, 2)
    w = Vector{Float64}(df[!, design.weights])
    newdf = copy(df)
    for r = 1:replicates
        rw = copy(w)
        for (k, stratum) in enumerate(order)
            first_psu, second_psu = psu_rows[stratum]
            if H[1+k, r] == 1
                rw[first_psu] .*= 2 - fay_rho
                rw[second_psu] .*= fay_rho
            else
                rw[first_psu] .*= fay_rho
                rw[second_psu] .*= 2 - fay_rho
            end
        end
        newdf[!, "replicate_"*string(r)] = rw
    end
    return ReplicateDesign{BRRReplicates}(
        newdf,
        design.cluster,
        design.popsize,
        design.sampsize,
        design.strata,
        design.weights,
        design.allprobs,
        design.pps,
        fay_rho == 0 ? "brr" : "fay",
        UInt(replicates),
        [Symbol("replicate_"*string(r)) for r = 1:replicates],
        BRRReplicates(UInt(replicates), Float64(fay_rho)),
    )
end

# Sylvester construction in ±1 form: order is the smallest power of two >= min_order.
function _sylvester_hadamard(min_order::Integer)
    H = ones(Int, 1, 1)
    while size(H, 1) < min_order
        H = [H H; H -H]
    end
    return H
end

# Accept a Hadamard matrix in 0/1 or ±1 form and return it in ±1 form.
function _normalize_hadamard(M::AbstractMatrix)
    values = sort!(unique(M))
    H = values == [0, 1] ? 2 .* M .- 1 : M
    sort!(unique(H)) == [-1, 1] && H * H' == size(H, 1) * I ||
        throw(ArgumentError("hadamard_matrix is not a Hadamard matrix"))
    return H
end

"""
    standarderror(x, func, design::ReplicateDesign{BRRReplicates}, args...; kwargs...)

Compute the standard error of an estimator using BRR (or Fay) replicate weights:
``\\hat{V} = \\sum_r (\\hat{\\theta}_r - \\hat{\\theta})^2 / (R(1-\\rho)^2)``.
"""
function standarderror(
    x::Union{Symbol,Vector{Symbol}},
    func::Function,
    design::ReplicateDesign{BRRReplicates},
    args...;
    kwargs...,
)
    θs = func(design.data, x, design.weights, args...; kwargs...)
    θts = [
        func(design.data, x, "replicate_" * string(i), args...; kwargs...) for
        i = 1:design.replicates
    ]
    θs = (θs isa Vector) ? θs : [θs]
    if !(θts[1] isa Vector)
        θts = [[θt] for θt in θts]
    end
    θts = hcat(θts...)
    scale = 1 / (design.replicates * (1 - design.inference_method.rho)^2)
    variance = [sum((θts[i, :] .- θs[i]) .^ 2) * scale for i in eachindex(θs)]
    return DataFrame(estimator = θs, SE = sqrt.(variance))
end
