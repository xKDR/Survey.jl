@testset "boxplot.jl" begin
    # SimpleRandomSample
    apisrs = load_data("apisrs")
    srs = srs = SurveyDesign(apisrs; weights=:pw);
    bp = boxplot(srs, :stype, :enroll; weights = :pw)

    @test bp.grid[1].entries[1].positional[2] == srs.data[!, :enroll]
    @test bp.grid[1].entries[1].named[:weights] == srs.data[!, :pw]

    # StratifiedSample
end
