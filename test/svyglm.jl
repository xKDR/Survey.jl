using Survey
using Test

function genWts(data,chaos)
    if chaos==1
        wts = ones(size(data)[1])
    else
        wts = ones(size(data)[1])
        wts[1] = 200
    end
    wts
end

@testset "svyglm.jl" begin
    rtol=0.1 #rtol which test uses is diffrent from 
    data(api)

    rcoef = [19.852539307789417, 0.016802996766905515]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [13.821691894538569, 0.020932345630754703]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.04873273798101878, -2.545900442141623e-5]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.06602717760486693, -4.837774447484219e-5]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.000475022138835, 0.0006674250431904819]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.626328291498775, 0.001128251554586315]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.4675561050493435, 0.0016794583729629272]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.6919682339147015, 0.0024858792643755187]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [20.81754723634115, 0.014574128759780829]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [16.9504183227201, 0.013414574139003429]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.047326430818283034, -2.273224677320802e-5]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.06092784931279272, -3.790260657717406e-5]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.0427930460495958, 0.0005781143228868981]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.8081808689622867, 0.0007223757899528744]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.5709143099027445, 0.001451428755866715]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.093801084880702, 0.001554601904188512]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [20.396962685204315, 0.015578775639845489]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [15.757897032885943, 0.016354051972422335]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.04802942131078968, -2.4136270761976737e-5]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.06396051126631712, -4.4334324326067683e-5]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.023674047116632, 0.0006198204624428633]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.7306451504600457, 0.0009013786283701581]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.525317648001372, 0.0015554611944026753]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.937974903181009, 0.001926878861268805]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.476009259711357, 0.45896567043916364, -0.2189808315090155, 0.016762348305265986]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(growth~meals+ell+dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [7.405836020305114, 0.4072566213513245, -0.15502327824484397, 0.014823594631887456]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(growth~meals+ell+dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [17.499309726273815, 1.0362247060905792, 0.20689279530841123]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [10.618862171412498, 0.9470888770809175, 0.2554170143650083]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.03105097698342063, -0.00025951964795808497, -4.980649281479226e-5]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.03564902053538176, -0.00029846548118673334, -7.127665001634578e-5]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.200988225159865, 0.01853539304483344, 0.004401765720794799]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.016183666106752, 0.019353379360543335, 0.005674410063167833]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.4050112100743, 0.07570792572126114, 0.01816200488597775]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.972520325284209, 0.07053682209109562, 0.02109203630823282]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [96.58554019967326, 0.09528706473480851, 0.04746149077760165, -0.29581091687660227]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [102.56903957327081, 0.2994671678196024, 0.05694530556083325, -0.45227877815926576]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010298668498595407, -1.1475337581433332e-5, -6.476114427094932e-6, 3.866960426539555e-5]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.00971042834048784, -4.293936615201201e-5, -6.686320985047049e-6, 5.7285543560066516e-5]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.573015337880906, 0.0010496565303077222, 0.0005597422989190293, -0.0033886072141109664]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.632906410122461, 0.0036298370322293233, 0.0006277035681771951, -0.005127700303215906]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.834055808096808, 0.0050047147493627675, 0.00258380795582847, -0.015837488847978982]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [10.13399218244361, 0.016534390287256482, 0.0030050612704961583, -0.024121159310513514]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [97.04322155899567, 0.11444814943941939, 0.04894444703603661, -0.3154905816230446]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [103.36576358179042, 0.27958665616726947, 0.06210745944693044, -0.4640788209061506]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010259348226255835, -1.3551287902882181e-5, -6.804004558645566e-6, 4.085883946939977e-5]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.009620561658963203, -4.1340773001206705e-5, -7.77958780972283e-6, 5.957478962653988e-5]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.57722584780227, 0.0012472563878204615, 0.0005829761882771319, -0.0035939835822592836]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.641357580037837, 0.0034312167113636086, 0.00071388149921673, -0.005291340773091543]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.855962779482573, 0.005975538095906088, 0.0026782307142671764, -0.016840058593652295]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [10.174989337839179, 0.015526010287809732, 0.003356942476353457, -0.02481863615015127]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [96.78174537092866, 0.10403982721444952, 0.04811675254370905, -0.30465358460709974]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [102.93852488351948, 0.28896639160064413, 0.0597468338664144, -0.4574349763919181]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.01028153721826924, -1.2443211144164435e-5, -6.630761733850919e-6, 3.967635761261705e-5]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.009668490487342555, -4.2193491493239046e-5, -7.206862262535231e-6, 5.8378528534779286e-5]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.574836900133671, 0.0011409175094760585, 0.0005704953953500102, -0.0034820528248527775]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.636835034133741, 0.0035296478514372305, 0.0006704849256610509, -0.005202532036672366]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.843493008377969, 0.005450655556148467, 0.0026267322072815956, -0.016290879285155466]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [10.153024510485578, 0.016012306833782283, 0.003185833666927896, -0.024432788452762772]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [93.82000643799564, 0.032714209742078004, -0.027322045119543895]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [93.82846194140612, 0.032704317447096384, -0.027327105792050974]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.01063501615215185, -3.3548983370761818e-6, 2.7996866875279524e-6]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.01063573587989556, -3.355628580324203e-6, 2.7991420970934927e-6]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.542522453794568, 0.0003313304964353771, -0.0002766121742660158]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.542530169818557, 0.000331322066236489, -0.00027661739942401377]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.68888483545306, 0.0016461974399421373, -0.001374601593992681]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.689117241108823, 0.0016459348302332616, -0.0013747501452265492]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [93.7681632462419, 0.03309794966873599, -0.02763990805626656]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [93.7948170030615, 0.03306397401308171, -0.0276529878883247]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010640396277748213, -3.3949562818952374e-6, 2.8329786089132253e-6]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010639296824781657, -3.393730062080016e-6, 2.833696372778119e-6]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.54199424095025, 0.0003352523414203465, -0.00027986631489690383]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.542184017118389, 0.00033502548614321057, -0.000279974732243069]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.686268493077382, 0.0016655938946646084, -0.0013906821665282774]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.687411021387943, 0.0016641834373892195, -0.0013912894932434584]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [93.79425168307411, 0.03290474796528548, -0.02747990117196297]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [93.81169317983408, 0.032883440833357924, -0.027489412238860728]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010637689518962693, -3.374790155020553e-6, 2.8162208220632363e-6]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010637511053698747, -3.3746001369769957e-6, 2.8163466313745392e-6]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.542260056838586, 0.00033327761172990305, -0.00027822803717126405]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.54235764872683, 0.00033316608351502614, -0.0002782890764011935]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.687584823332436, 0.001655829977966438, -0.0013825887368813059]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.688266708309156, 0.0016550238100658532, -0.0013829878528847806]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [13.810831277596188, 0.31523877591740934]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(growth~meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [13.649256827507362, 0.31664824141234876]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(growth~meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [12.313991611568767, 0.09081027644029858]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.054897182273514, 0.119240397293647]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.07516798436631947, -0.0002901194904550819]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.09425628209020485, -0.0004983617414145051]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.5564115357446133, 0.005121203237218301]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.2952503238004067, 0.007883880687574145]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.553454726833889, 0.010778623695115919]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.0839429944953802, 0.015466993740961069]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [11.613082768340933, 0.10746041110244206]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.354958120506199, 0.11118815542811016]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.07698785070208947, -0.00032269454273518557]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.0950437919713874, -0.0005140366435911466]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.520096325684129, 0.005861604838146036]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.2959818816454685, 0.007865038609518699]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.473276551733995, 0.012536527872094224]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.1043143405178815, 0.01495305289832234]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [12.009772837768539, 0.09757144487679642]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.204694341305, 0.1154006782615505]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.07596610583667521, -0.00030382549601011566]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.09462468372609342, -0.0005052680185240707]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.540525387358834, 0.005428890150162429]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.2950326950962068, 0.007888508617627793]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.5185108949759534, 0.011501587664729895]
    apistrat.wts = genWts(apistrat,1)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.092836130186039, 0.015254388159506728]
    apistrat.wts = genWts(apistrat,2)
    sd = svydesign(data=apistrat,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [33.6084325542773, -0.005375331118991334]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [39.679599355676565, -0.04561035202548833]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.02945276542256612, 5.995955704110545e-6]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.015021044227906446, 0.00011440794587404663]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.5193936176789187, -0.0001790606328083504]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.8681535659383326, -0.0023837748207087782]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [5.803681258038523, -0.0004902638734413207]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [6.607322649924698, -0.0053450503387416125]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.029657127683424198, 5.464318207618596e-6]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.012285606750201688, 0.0001271015752112013]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.5135990865026363, -0.00016458932419128794]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.736710402810912, -0.0021066177395622355]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [5.788166924530174, -0.00045224932753613217]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.029560537101786844, 5.711668214418187e-6]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.013651766694489979, 0.00012206005677876978]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.516356929247808, -0.00017138229820086258]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.8560252928224816, -0.002352665272706395]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [5.795565626257508, -0.00047014410019493165]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [6.3575094132992565, -0.0047912177647261986]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [12.241096093599847, -0.019335518503428153, 0.6511483736914527, 0.019335321551248532]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(growth~meals+ell+dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [11.917944512214367, -0.15179706694825687, 0.7855459974961514, 0.029589449113631185]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(growth~meals+ell+dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [21.005257946639674, 0.9827280154221911, 0.06440098939709134]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [6.352198003579708, 1.3318472822744785, -0.12269369401616546]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.027792901997291015, -0.00025440519280463784, -1.7283397138803052e-6]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.040600875904590064, -0.00047563577795723067, 3.469068821071962e-5]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.39544398317539, 0.016829838807992666, 0.0006057859458406191]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.8943948034882707, 0.02838907699404031, -0.002922129069810155]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [5.06194201193598, 0.06626668368659366, 0.0034032563958906505]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.5209221799040256, 0.10630810917708457, -0.010756449992144744]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [23.951994049494704, 0.8476808238116741, 0.07432666726600255]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.03049724650374688, -0.00031040801568211357, -8.65111043794249e-6]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.04444131725553145, -0.0005992844618031765, 6.729349738539915e-5]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.294386557501264, 0.018892903837350317, 0.0013626494243970657]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.909071624307819, 0.026532177379337444, -0.002421939822045831]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.997536119654526, 0.06528667192785456, 0.005541577438365458]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol


    rcoef = [22.27893587644691, 0.9249351756659369, 0.07306160622542461]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.02900153868999018, -0.0002787483789302613, -3.714046173347455e-6]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.04250716415868932, -0.0005313757155334976, 5.074691632759612e-5]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.3384521314092517, 0.018019245870671954, 0.0009269057356260197]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.8501735319279895, 0.029977873166426503, -0.0031733863598370888]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.9805779782576725, 0.06727363929756108, 0.004599642547288176]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.839737043387107, 0.09072877337608513, -0.008027613943817407]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [96.03716474761991, -0.09308529164420191, -0.036018740662903614, -0.08783495038760757]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [90.3532717624607, -0.16995872954241745, -0.0794215124999823, 0.055299585889525125]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.01033909445120728, 1.4027187847251898e-5, 5.118455742927665e-6, 1.011366679594371e-5]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010945924318483602, 2.6240415050236824e-5, 1.1519196624599343e-5, -7.582469261208434e-6]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.568200842570717, -0.001150346080770433, -0.000431346173217862, -0.0009431197751283893]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.5091882292109515, -0.002118374127034952, -0.0009608541532906671, 0.0006488825394376682]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.808247179639459, -0.005183079743361119, -0.001973243115231818, -0.004551504760315564]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.518283909884522, -0.009493008999780896, -0.004372438890290817, 0.002996492388453739]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [96.19997349022383, -0.08112540464795365, -0.03337353092988485, -0.09950248367709875]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [89.80111693127198, -0.15240190328661482, -0.07479753872974587, 0.05302799980394516]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010318813114430597, 1.2636763157210844e-5, 4.828607750973035e-6, 1.1505682120285014e-5]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.01102274615789953, 2.353694021052259e-5, 1.0981916918685278e-5, -7.2900996490785434e-6]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.569981640922017, -0.001020531709309143, -0.0004035288855108989, -0.0010703663583560355]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.502545685860094, -0.0018968912882356078, -0.000909411252982136, 0.000622692170254524]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.816713667155282, -0.00455912936908498, -0.0018374552022377537, -0.005160446307074326]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.487874891964788, -0.0085036465505177, -0.004126936781971756, 0.002874125349800617]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [96.11073916966183, -0.08712890881687134, -0.03470691705860483, -0.09351077144199814]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [90.0662131882656, -0.16069925408764113, -0.07706125540266325, 0.05412225524672907]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010329599340290442, 1.3335833800504176e-5, 4.975046630228947e-6, 1.0794485882605418e-5]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010985138174732451, 2.4834231191175263e-5, 1.1253811080152784e-5, -7.432930068597907e-6]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.569020069648979, -0.001085736387074946, -0.0004175679706983154, -0.0010051986301528165]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.505759774633123, -0.0020021728348470834, -0.0009349398788967742, 0.0006353847329247284]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.81210659920837, -0.00487240223582593, -0.0019059456220664262, -0.004848172760120932]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.502525731572922, -0.008972392904489234, -0.004247868830253232, 0.0029332273499584416]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [95.98893837597574, 0.0020960735021797266, 0.0027002245697935108]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [93.79511451018823, -0.0028859724945897707, 0.010208612864784947]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010407216183973248, -2.189097324293306e-7, -2.680253702441079e-7]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010644049752293425, 2.9653800869084056e-7, -1.0616672483584035e-6]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.564754639383343, 2.1426512833542692e-5, 2.6901137258989773e-5]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.541949724453297, -2.9255050298881498e-5, 0.0001041169630217841]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.798685241433185, 0.00010596871257151579, 0.00013475723968354983]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.686834861073187, -0.0001452845945416358, 0.0005154955040020731]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [95.97505170833615, 0.0020414618237609003, 0.0027810754686418315]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [93.83095148212792, -0.002931568660409474, 0.010196038392819766]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.01040864645309545, -2.1360808510942383e-7, -2.760009268015381e-7]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010640528012209534, 3.0125000182228103e-7, -1.0606927910520759e-6]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.56461366896614, 2.0888338015041562e-5, 2.7704246128490972e-5]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.542305473848398, -2.9718669103659766e-5, 0.00010400459642094935]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.797985475185868, 0.00010325737037441503, 0.00013878722330251187]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.688620894219156, -0.00014758393432827202, 0.000514899387580319]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [95.98200837110346, 0.002069019624359683, 0.002740353337861943]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [93.81299654257235, -0.002908827511031285, 0.010202460545207983]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.01040792954438476, -2.1628463658097162e-7, -2.7198221219006557e-7]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010642294973494804, 2.9889919723739873e-7, -1.0611971339654083e-6]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.564684299216584, 2.1159935740659737e-5, 2.7299716458315883e-5]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.54212705622947, -2.9487270939920538e-5, 0.00010406226398345519]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.798336223309624, 0.00010462626847812745, 0.00013675640549820373]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.68772560477788, -0.00014643673068323988, 0.0005152045531879398]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [21.167610614103, 0.31707690934463073]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(growth~meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [39.58046593197649, 0.06449167349644262]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(growth~meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [12.090620308879862, 0.1132587027979]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [12.832173614643434, 0.1030861677186473]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [12.021198719138594, 0.1146324215395372]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [12.822689686481139, 0.10336422900945573]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.07378016352719716, -0.00032235346434947635]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.07290466475616456, -0.00031153430201177396]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.550081370417678, 0.006252315172727608]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.5875951193039626, 0.005752547055895223]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.523547778919546, 0.01349352049543981]
    apiclus1.wts = genWts(apiclus1,1)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.615139565189028, 0.012234478433057711]
    apiclus1.wts = genWts(apiclus1,2)
    sd = svydesign(data=apiclus1,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [27.011269086057517, 0.003306192641207121]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [29.734049229078398, -0.0014070978500682226]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.036938393932331164, -4.063172858912875e-6]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.03362313700719904, 1.6781725044485508e-6]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.2973536965077845, 0.00011602267513052464]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.3924146112829914, -4.8583837257764576e-5]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [5.1986478770345155, 0.00030975374140493827]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [5.45305834407665, -0.00013072506464489688]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.036952194300148095, -4.091077081292087e-6]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.03362979906986281, 1.6426568649014016e-6]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.297120670062287, 0.0001165008822296672]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.392222217346555, -4.7584480751816696e-5]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [5.198235306324976, 0.00031060672832945165]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [5.4525416725551095, -0.00012807537447841126]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [27.00956101107512, 0.003309740103588972]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [29.731254655169913, -0.0013928292921025396]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.0369460820311807, -4.0786483407123045e-6]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.03362649700530502, 1.6601034700652453e-6]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.2972152168020687, 0.0001163056530614922]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.3923176684279333, -4.807598830577685e-5]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [5.198383722058313, 0.0003102978033010925]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [5.45279759934814, -0.00012937662394039547]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [17.60045300824547, 0.4401307103518129, -0.2963239543592062, -0.0064756189409267105]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(growth~meals+ell+dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [23.366592068220267, 0.4579682134496839, -0.38234614425540525, -0.015537773084009322]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(growth~meals+ell+dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [12.56943704549076, 1.2488227303735902, 0.22499718656631085]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [15.782434939170027, 1.109970069168465, 0.27018542019039005]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.03765607369805905, -0.0004569825787645028, -1.3387955820354623e-5]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.037581405798499494, -0.0004552900675052336, -1.3784259156516248e-5]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.9888346810284623, 0.025631126141300413, 0.004237770493224647]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.0775582657514304, 0.022813907586810494, 0.004942217095911617]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.9291890330013164, 0.09461176914137939, 0.01881611879880435]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.248852659908276, 0.08141677047777836, 0.02261652011414011]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [95.45020244242633, 0.0005588104719308948, 0.07184620304870884, -0.11719767549448347]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [97.50830278066785, -0.1501915695578266, 0.0991286642643912, -0.0827072162975507]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010471398184637227, -2.287779697832461e-7, -8.420925532842145e-6, 1.4029146029205811e-5]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010251518986302837, 1.854053299246571e-5, -1.066542888306889e-5, 9.049022040323355e-6]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.558880071814485, 1.5518260652862364e-5, 0.0007804112370919204, -0.0012855797672350405]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.580125691479207, -0.0016634598760997912, 0.0010334112706571997, -0.0008715288619721561]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.770566179984149, 5.416592024853234e-5, 0.0037471027054722106, -0.006141369936511209]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.875087326434127, -0.007895923900889997, 0.005067185630205803, -0.004253232806394067]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [95.3892306817184, -0.004280987804747864, 0.07030851863109519, -0.11254932145244756]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [97.42516077240988, -0.14545429897550416, 0.10006778624810236, -0.081908878573277]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010476821402501613, 2.2773503010888788e-7, -8.35416858377594e-6, 1.364078865343635e-5]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010260143273310084, 1.7561848408119722e-5, -1.1021537892053484e-5, 9.310316299235217e-6]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.558306030733681, -3.1860165672387765e-5, 0.0007688343373653318, -0.0012422786842810297]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.579285034632418, -0.0015912476819282507, 0.0010557053716828647, -0.0008803886849389655]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.76760761267514, -0.00018578256887032257, 0.003678952020250707, -0.005916020059623148]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.870913679440493, -0.007597670411100468, 0.005145852613271459, -0.0042547667579689455]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [95.4207615435587, -0.001796603812703806, 0.07111531283749667, -0.11493754633496521]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [97.4676223518129, -0.14745592552744205, 0.0997382122143591, -0.08253357296678293]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010474021950952017, -9.28166853800264e-9, -8.393704840108051e-6, 1.3844484817938591e-5]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010255782012722644, 1.8014865770872542e-5, -1.0856010322072613e-5, 9.199778637433041e-6]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.558603013451985, -7.402002325582733e-6, 0.0007751389155923243, -0.001264742977847314]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.579712287270685, -0.0016236520821931214, 0.0010459610650708719, -0.0008781884977022112]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.769138499888868, -6.224448665522241e-5, 0.0037152964599643182, -0.006032367083667221]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.87304041592248, -0.007728297155601642, 0.005113619975757302, -0.004265337911943751]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(full~ell+growth+meals),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [14.53576103415235, 0.3202608744513976]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(growth~meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [25.020794198515205, 0.23479025486014074]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(growth~meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [12.76310479339429, 0.09708826730389312]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [11.630532315251829, 0.10632063404240416]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.07441320727925439, -0.0003184272913034482]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.07953385436246366, -0.00037495300789860676]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.5706849654989345, 0.005672599554745491]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.4934549317488672, 0.006499278608911069]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.592865175451691, 0.011798948393309843]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.4435763394989913, 0.013274331461837475]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [12.881903718693145, 0.09362179374541775]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [11.991554948704405, 0.09418865315916253]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.07517164786272039, -0.00033352515401263743]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.07984623288093695, -0.00038294500546953535]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.5690688537524875, 0.005707914917914804]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.501637438666087, 0.006249588711716856]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.599745092745747, 0.011612791584109484]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.4755712426357372, 0.012250438779389793]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [12.818133337538974, 0.09559845282984288]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [11.804674184014628, 0.1006762631091293]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.07484165355326194, -0.00032655750027481777]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.07974585105130189, -0.0003801983903780943]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.5690292767409866, 0.00570933814907725]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.496142121256949, 0.006421623745290465]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.595079837431775, 0.01174392442459022]
    apiclus2.wts = genWts(apiclus2,1)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.4573083909377567, 0.012853608051332578]
    apiclus2.wts = genWts(apiclus2,2)
    sd = svydesign(data=apiclus2,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [22.23439009133479, 0.012149721254178248]
    apipop.wts = genWts(apipop,1)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [19.379529133476442, 0.01742166488113855]
    apipop.wts = genWts(apipop,2)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.044591975674265094, -1.800163600556982e-5]
    apipop.wts = genWts(apipop,1)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.04856811075892835, -2.4546945309033293e-5]
    apipop.wts = genWts(apipop,2)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.104137912347123, 0.00047214256447071723]
    apipop.wts = genWts(apipop,1)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.995316601369728, 0.0006621119744598153]
    apipop.wts = genWts(apipop,2)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.717518227886106, 0.0011993560271005886]
    apipop.wts = genWts(apipop,1)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.437798064124778, 0.001701603911033396]
    apipop.wts = genWts(apipop,2)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [22.762355853199104, 0.010890816534124902]
    apipop.wts = genWts(apipop,1)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [19.184153968994853, 0.01792487652396429]
    apipop.wts = genWts(apipop,2)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.04379312473822179, -1.6349701448620263e-5]
    apipop.wts = genWts(apipop,1)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.04886103152540363, -2.513777150904968e-5]
    apipop.wts = genWts(apipop,2)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.126199258968172, 0.00042322960070233684]
    apipop.wts = genWts(apipop,1)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.9911201104493093, 0.0006717156962124961]
    apipop.wts = genWts(apipop,2)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.772150587890555, 0.001073798269964286]
    apipop.wts = genWts(apipop,1)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.424993204844972, 0.0017327856012052977]
    apipop.wts = genWts(apipop,2)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [22.52319890293024, 0.011476311849907966]
    apipop.wts = genWts(apipop,1)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [19.331830023124613, 0.017536405545714867]
    apipop.wts = genWts(apipop,2)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.04417974224219384, -1.7169152638988327e-5]
    apipop.wts = genWts(apipop,1)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.04870474977209929, -2.4813549674945644e-5]
    apipop.wts = genWts(apipop,2)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.1160082436544827, 0.0004464195161463967]
    apipop.wts = genWts(apipop,1)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.994332284456228, 0.0006642503312315288]
    apipop.wts = genWts(apipop,2)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.7472404972029, 0.0011325722413844626]
    apipop.wts = genWts(apipop,1)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.43527072494797, 0.001707409990271073]
    apipop.wts = genWts(apipop,2)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [23.27674238741806, 0.2265038812633155, -0.00983094170459761, -0.002640596086200574]
    apipop.wts = genWts(apipop,1)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(growth~meals+ell+dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [25.370353249623857, 0.20538405354664227, 0.007899341624985498, -0.005378728200668248]
    apipop.wts = genWts(apipop,2)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(growth~meals+ell+dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [20.221785634008462, 1.0685971201271238, 0.1027513982394961]
    apipop.wts = genWts(apipop,1)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [19.27922518039677, 1.0828137394397237, 0.09586409553223135]
    apipop.wts = genWts(apipop,2)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.02921238961457218, -0.00024953358486822603, -2.0100348861915888e-5]
    apipop.wts = genWts(apipop,1)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.029860332287800304, -0.0002584426611375959, -1.895714110208761e-5]
    apipop.wts = genWts(apipop,2)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.2861593680350025, 0.018434020710060492, 0.002082857777291423]
    apipop.wts = genWts(apipop,1)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.2578407478391203, 0.018896914028401737, 0.0019930414448396305]
    apipop.wts = genWts(apipop,2)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.710235887248018, 0.07597655522651227, 0.008326425900809984]
    apipop.wts = genWts(apipop,1)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.6368022388746715, 0.07711454809242572, 0.007855745686824159]
    apipop.wts = genWts(apipop,2)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [22.166081452544613, 0.22136802130499902]
    apipop.wts = genWts(apipop,1)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(growth~meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [23.217489630436187, 0.20742473434125808]
    apipop.wts = genWts(apipop,2)
    sd = svydesign(data=apipop,weights=:wts)
    jcoef = svyglm(@formula(growth~meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [21.650497884802157, 0.010062258530350853]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [15.35079371648053, 0.010789008933764766]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.04635672714581871, -1.734629735040647e-5]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.0756971167146116, -5.52124732894222e-5]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.071106349570877, 0.00042181523025128627]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.605024332066764, 0.0008751857555967217]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.647488946818263, 0.0010317473465799375]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.80601783995445, 0.001522967962829505]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [22.27052208954838, 0.008619250571327296]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.04525938933001788, -1.508817945336351e-5]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.06199168147294855, -2.702923670413523e-5]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.0985569829286574, 0.0003617521980159552]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.82683644686873, 0.0003875904288854227]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.713276960829454, 0.0008832981950201349]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.146048442631385, 0.0007531548099478192]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [21.98820569449091, 0.00929075174026864]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [16.714541439893186, 0.0076530171542340646]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.04578484118130555, -1.6194183092118965e-5]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.06826295663324547, -4.045740695109782e-5]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.085876554263612, 0.00039013243354418185]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.758193027328452, 0.0005431593616227393]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.68319697148335, 0.0009527027756396931]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.03634850583009, 0.0010069046509206749]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(cnum~dnum),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [24.82758069617155, 0.29286700952579436, -0.03691707470178347, -0.015295946199160597]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(growth~meals+ell+dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [15.918845413841463, 0.47359734194085656, -0.315499444817528, -0.015108840993373984]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(growth~meals+ell+dnum),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [22.66672036065673, 0.935692198094081, 0.1592001186738126]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [18.024577819737416, 0.8510129277921251, 0.24725334660838746]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [18.099336966787398, 0.8609168623565143, 0.23219125882826197]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.028499566477846162, -0.00021378711667711803, -5.356345419722975e-5]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.029760993395621924, -0.00022181936917489264, -6.328125974334514e-5]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.358908660414955, 0.015906123249569144, 0.003126673407781379]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.2833974839712683, 0.01581238650376551, 0.004084526918153274]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.962994355580012, 0.06610488008628344, 0.011662470868456358]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.713235440661724, 0.061550100222985245, 0.01637522740421099]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(meals~ell+growth),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [95.21202843265861, 0.017003718835692697, -0.012776703721702535]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [96.50687250475366, 0.012448891628779435, -0.009830114718549651]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010491164829391124, -1.7415002720766583e-6, 1.306050744614016e-6]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010358454770769356, -1.277530313276944e-6, 1.0066062453698471e-6]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.5566742056722935, 0.0001721078418155973, -0.00012920286803554638]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.569785116214157, 0.00012611837038504933, -9.948212900254918e-5]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.759063360836693, 0.0008553805085390379, -0.0006424458516566352]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.82421324184559, 0.0006265148456543873, -0.0004944595873635184]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Normal(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [95.19897220467752, 0.017106586862824846, -0.012863906853071563]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [96.50754129204527, 0.012484997800712633, -0.009869011930619832]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.01049258733947373, -1.753113256391414e-6, 1.315989194899257e-6]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010358391909760878, -1.281581353760541e-6, 1.010948644379981e-6]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.556537767977723, 0.00017320330673554853, -0.0001301362310643327]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.56979160769325, 0.00012650126864536293, -9.98935468578143e-5]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.758395738260907, 0.0008606921127718869, -0.0006469604135616767]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.824246196624872, 0.0006283744981996406, -0.0004964603113298763]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Gamma(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [95.20548474291016, 0.01705560394852365, -0.012820763202976856]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [96.50720669487956, 0.012467110352926788, -0.009849736292381363]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010491877069819897, -1.7473443873234547e-6, 1.3110589060458006e-6]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.010358423358912553, -1.2795719372383925e-6, 1.0087942838682328e-6]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.5566058616573315, 0.0001726597035805286, -0.00012967378159337847]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [4.56978835984881, 0.00012631145729649884, -9.968954901681832e-5]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.758728938646206, 0.0008580571492429526, -0.0006447245061143383]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [9.82422970863238, 0.0006274529139253154, -0.0004954685576497072]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(pcttest~api00+api99),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [17.618057537052124, 0.2855817329123753]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(growth~meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [7.055586336420611, 0.3385660012670978]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(growth~meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [14.452546232206487, 0.06013704794628077]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [7.208916670262022, 0.09647309140449355]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Normal(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [14.551824595499689, 0.05815187771446325]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [8.71612535007701, 0.06441336951270263]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),IdentityLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.06818079188235583, -0.0002048934351749668]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [0.12917734532987823, -0.0008410752426298812]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),InverseLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.682504168784929, 0.003441095906950557]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.078774738912212, 0.0078697423218258]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),LogLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [3.8197222674497087, 0.0070671224153743325]
    apisrs.wts = genWts(apisrs,1)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

    rcoef = [2.892120154959868, 0.011198654714211375]
    apisrs.wts = genWts(apisrs,2)
    sd = svydesign(data=apisrs,weights=:wts)
    jcoef = svyglm(@formula(mobility~meals),sd,Poisson(),SqrtLink()).coefficients
    @test  maximum(abs.((jcoef-rcoef)./rcoef))<=rtol

end
