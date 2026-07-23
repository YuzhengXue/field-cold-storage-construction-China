
**************************************************
* Figure 2
* Standardized effects of cold-storage exposure
* on agricultural product loss reduction
**************************************************


clear all
set more off

input str30 variable coef t
"CSC"        4.43 115.47
"Amount"     3.01 77.16
"Capacity"   1.52 37.12
end

gen se = abs(coef/t)
gen ci_low = coef - 1.96*se
gen ci_high = coef + 1.96*se
gen y = _n
gen label = string(coef, "%4.2f")

twoway ///
(rcap ci_low ci_high y if y==1, horizontal lcolor("34 94 110") lwidth(medthick)) ///
(scatter y coef if y==1, msymbol(circle) mcolor("34 94 110") msize(medium)) ///
(scatter y coef if y==1, msymbol(none) mlabel(label) mlabposition(12) mlabgap(2) mlabsize(medium) mlabcolor("34 94 110")) ///
(rcap ci_low ci_high y if y==2, horizontal lcolor("100 122 142") lwidth(medthick)) ///
(scatter y coef if y==2, msymbol(circle) mcolor("100 122 142") msize(medium)) ///
(scatter y coef if y==2, msymbol(none) mlabel(label) mlabposition(12) mlabgap(2) mlabsize(medium) mlabcolor("100 122 142")) ///
(rcap ci_low ci_high y if y==3, horizontal lcolor("180 126 94") lwidth(medthick)) ///
(scatter y coef if y==3, msymbol(circle) mcolor("180 126 94") msize(medium)) ///
(scatter y coef if y==3, msymbol(none) mlabel(label) mlabposition(12) mlabgap(2) mlabsize(medium) mlabcolor("180 126 94")), ///
yscale(reverse) ///
ylabel(1 "Construction" 2 "Amount" 3 "Capacity", angle(0) labsize(medium) noticks nogrid) ///
xlabel(1(1)5, labsize(medium) nogrid) ///
xscale(range(1 5)) ///
xtitle("Loss-rate reduction (percentage points)", size(medium)) ///
ytitle("") ///
legend(off) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
aspectratio(0.3)

graph export "E:\学习\科研\产地冷库（undergoing)\相关数据\history处理记录\画图\Figure2_standardized_effect_styled.png", replace






**************************************************
* Figure 3
**************************************************

clear all
set more off

input str40 variable coef t
"Construction"          -38.99   -8.42
"Amount"                  -7.782  -17.06
"Capacity"                -12.000  -15.44
end

gen se = abs(coef / t)
gen ci_low = coef - 1.96 * se
gen ci_high = coef + 1.96 * se
gen y = _n
gen label = string(coef, "%5.2f")

twoway ///
(rcap ci_low ci_high y if y==1, horizontal lcolor("34 94 110") lwidth(medthick)) ///
(scatter y coef if y==1, msymbol(circle) mcolor("34 94 110") msize(medium)) ///
(scatter y coef if y==1, msymbol(none) mlabel(label) mlabposition(12) mlabgap(2) mlabsize(medium) mlabcolor("34 94 110")) ///
(rcap ci_low ci_high y if y==2, horizontal lcolor("100 122 142") lwidth(medthick)) ///
(scatter y coef if y==2, msymbol(circle) mcolor("100 122 142") msize(medium)) ///
(scatter y coef if y==2, msymbol(none) mlabel(label) mlabposition(12) mlabgap(2) mlabsize(medium) mlabcolor("100 122 142")) ///
(rcap ci_low ci_high y if y==3, horizontal lcolor("180 126 94") lwidth(medthick)) ///
(scatter y coef if y==3, msymbol(circle) mcolor("180 126 94") msize(medium)) ///
(scatter y coef if y==3, msymbol(none) mlabel(label) mlabposition(12) mlabgap(2) mlabsize(medium) mlabcolor("180 126 94")), ///
yscale(reverse) ///
ylabel(1 "Construction" 2 "Amount" 3 "Capacity", angle(0) labsize(medium) noticks nogrid) ///
xlabel(-50(10)0, labsize(medium) nogrid) ///
xscale(range(-50 0)) ///
xline(0, lcolor("160 160 160") lpattern(dash) lwidth(thin)) ///
xtitle("Estimated coefficient on agricultural carbon emissions", size(medium)) ///
ytitle("") ///
legend(off) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
aspectratio(0.3)

graph export "E:\学习\科研\产地冷库（undergoing)\相关数据\history处理记录\画图\Figure3_carbon_emissions_combined_styled.png", replace








**************************************************
* Figure 4
**************************************************
*******************************************************
* Income growth: baseline OLS versus matched-pair FE
*******************************************************
clear all
set more off
*------------------------------------------------------*
* 1. Input regression results
*------------------------------------------------------*

input str12 model str24 exposure double coef double se double y

/* Baseline OLS */
"OLS"       "Construction"       15.53214   0.2092664   3.12
"OLS"       "Facility number"     5.239726  0.0937262   2.12
"OLS"       "Capacity"            0.35168   0.01084     1.12

/* Matched-pair fixed effects */
"Matched"   "Construction"       20.22888   0.3369902   2.88
"Matched"   "Facility number"     8.609713  0.2313755   1.88
"Matched"   "Capacity"            0.86531   0.04118     0.88

end

*------------------------------------------------------*
* 2. Construct confidence intervals
*------------------------------------------------------*

gen ci_low  = coef - 1.96 * se
gen ci_high = coef + 1.96 * se

gen ols     = model == "OLS"
gen matched = model == "Matched"

*------------------------------------------------------*
* 3. Create variables for three background rectangles
*
* Horizontal bars extend from -2 to 23.
*------------------------------------------------------*

gen band_y   = .
gen band_end = .
gen band_id  = .

* Light-purple band
replace band_y   = 3  in 1
replace band_end = 23 in 1
replace band_id  = 1  in 1

* Light-yellow band
replace band_y   = 2  in 2
replace band_end = 23 in 2
replace band_id  = 2  in 2

* Light-green band
replace band_y   = 1  in 3
replace band_end = 23 in 3
replace band_id  = 3  in 3

*------------------------------------------------------*
* 4. Draw graph
*------------------------------------------------------*

twoway ///
/* Light-purple background */ ///
(bar band_end band_y if band_id == 1, ///
    horizontal ///
    base(-2) ///
    barwidth(0.90) ///
    color("235 225 242") ///
    lcolor(none)) ///
/* Light-yellow background */ ///
(bar band_end band_y if band_id == 2, ///
    horizontal ///
    base(-2) ///
    barwidth(0.90) ///
    color("249 247 221") ///
    lcolor(none)) ///
/* Light-green background */ ///
(bar band_end band_y if band_id == 3, ///
    horizontal ///
    base(-2) ///
    barwidth(0.90) ///
    color("214 237 210") ///
    lcolor(none)) ///
/* Baseline OLS confidence intervals */ ///
(rcap ci_low ci_high y if ols, ///
    horizontal ///
    lcolor("255 128 90") ///
    lwidth(medthick)) ///
/* Baseline OLS points */ ///
(scatter y coef if ols, ///
    msymbol(circle) ///
    mcolor("255 128 90") ///
    mlcolor("255 128 90") ///
    msize(medium)) ///
/* Matched-pair FE confidence intervals */ ///
(rcap ci_low ci_high y if matched, ///
    horizontal ///
    lcolor("79 190 162") ///
    lwidth(medthick)) ///
/* Matched-pair FE points */ ///
(scatter y coef if matched, ///
    msymbol(square) ///
    mcolor("79 190 162") ///
    mlcolor("79 190 162") ///
    msize(medium)) ///
/* Zero-effect line: placed on the uppermost layer */ ///
(pci 0.55 0 3.45 0, ///
    lcolor(gs8) ///
    lpattern(dash) ///
    lwidth(thin)), ///
ylabel( ///
    3 "Construction" ///
    2 "Amount" ///
    1 "Capacity (per 100 tonnes)", ///
    angle(0) ///
    labsize(medsmall) ///
    noticks ///
    nogrid) ///
xlabel(0(5)20, ///
    labsize(medsmall) ///
    nogrid) ///
xscale(range(-2 23)) ///
yscale(range(0.5 3.5)) ///
xtitle("Change in income growth (percentage points)", ///
    size(medsmall) ///
    margin(medsmall)) ///
ytitle("") ///
legend( ///
    order(5 "Baseline OLS" 7 "Matched-pair FE") ///
    position(3) ///
    ring(0) ///
    cols(1) ///
    size(small) ///
    region(lcolor(none) fcolor(none))) ///
graphregion(color(white) margin(medsmall)) ///
plotregion(color(white) margin(small)) ///
xsize(6.5) ///
ysize(4.2) ///
name(income_coefficients, replace)
*------------------------------------------------------*
* 5. Export
*------------------------------------------------------*

graph export "E:\学习\科研\产地冷库（undergoing)\相关数据\history处理记录\画图\Figure4_income_growth.png", replace





**************************************************
* Figure 5
* Heterogeneous effects across local contexts
* Styled version: shaded bands + paired subgroup estimates
**************************************************

clear all
set more off

**************************************************
* Panel a: Food loss reduction
**************************************************

clear
set more off

input str20 subgroup coef t y type
"Family farms"     9.013   68.22   11   1
"Cooperatives"     8.812   93.54   10   2
"Near"             8.880  113.67    8   1
"Far"              8.635   20.76    7   2
"Inland"           9.047   66.14    5   1
"Coastal"          8.789   94.77    4   2
"Non-pilot"        8.767  107.57    2   1
"Pilot"            9.508   41.57    1   2
end

gen se = abs(coef/t)
gen ci_low = coef - 1.96*se
gen ci_high = coef + 1.96*se

* 背景条范围：从横轴最左边开始
gen xmin = 7.8
gen xmax = 10.2

* 右侧标签位置
gen labx = 10.15

twoway ///
(rbar xmin xmax y if y==11, horizontal barw(0.72) color("225 238 243") lcolor(none)) ///
(rbar xmin xmax y if y==10, horizontal barw(0.72) color("247 223 228") lcolor(none)) ///
(rbar xmin xmax y if y==8,  horizontal barw(0.72) color("225 238 243") lcolor(none)) ///
(rbar xmin xmax y if y==7,  horizontal barw(0.72) color("247 223 228") lcolor(none)) ///
(rbar xmin xmax y if y==5,  horizontal barw(0.72) color("225 238 243") lcolor(none)) ///
(rbar xmin xmax y if y==4,  horizontal barw(0.72) color("247 223 228") lcolor(none)) ///
(rbar xmin xmax y if y==2,  horizontal barw(0.72) color("225 238 243") lcolor(none)) ///
(rbar xmin xmax y if y==1,  horizontal barw(0.72) color("247 223 228") lcolor(none)) ///
(rcap ci_low ci_high y if type==1, horizontal lcolor("43 127 184") lwidth(medthick)) ///
(scatter y coef if type==1, msymbol(square) mcolor("43 127 184") msize(medium)) ///
(rcap ci_low ci_high y if type==2, horizontal lcolor("244 124 140") lwidth(medthick)) ///
(scatter y coef if type==2, msymbol(circle) mcolor("244 124 140") msize(medium)) ///
(scatter y labx if type==1, msymbol(none) mlabel(subgroup) mlabposition(9) mlabgap(0.2) mlabsize(small) mlabcolor("43 127 184")) ///
(scatter y labx if type==2, msymbol(none) mlabel(subgroup) mlabposition(9) mlabgap(0.2) mlabsize(small) mlabcolor("244 124 140")), ///
yscale(range(0.5 11.7)) ///
ylabel(10.5 "Organization" ///
       7.5  "Market access" ///
       4.5  "Region" ///
       1.5  "Governance", ///
       angle(0) labsize(small) noticks nogrid) ///
xlabel(8(0.5)10, labsize(small) nogrid) ///
xscale(range(7.8 10.25)) ///
xtitle("Food loss reduction", size(small)) ///
ytitle("") ///
title("a", size(large) position(11)) ///
legend(off) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
aspectratio(0.8) ///
name(fig5a, replace)

**************************************************
* Panel b: Agricultural carbon emissions
**************************************************

clear
set more off

input str20 subgroup coef t y type
"Family farms"     -17.86   -1.49   11   1
"Cooperatives"     -41.60   -8.39   10   2
"Near"             -37.92   -8.04    8   1
"Far"              -47.05   -2.01    7   2
"Inland"           -27.90   -5.81    5   1
"Coastal"          -59.37   -7.61    4   2
"Non-pilot"        -36.36   -7.41    2   1
"Pilot"            -44.49   -3.03    1   2
end

gen se = abs(coef/t)
gen ci_low = coef - 1.96*se
gen ci_high = coef + 1.96*se

gen xmin = -100
gen xmax = 20
gen labx = 19

twoway ///
(rbar xmin xmax y if y==11, horizontal barw(0.72) color("227 239 231") lcolor(none)) ///
(rbar xmin xmax y if y==10, horizontal barw(0.72) color("247 239 219") lcolor(none)) ///
(rbar xmin xmax y if y==8,  horizontal barw(0.72) color("227 239 231") lcolor(none)) ///
(rbar xmin xmax y if y==7,  horizontal barw(0.72) color("247 239 219") lcolor(none)) ///
(rbar xmin xmax y if y==5,  horizontal barw(0.72) color("227 239 231") lcolor(none)) ///
(rbar xmin xmax y if y==4,  horizontal barw(0.72) color("247 239 219") lcolor(none)) ///
(rbar xmin xmax y if y==2,  horizontal barw(0.72) color("227 239 231") lcolor(none)) ///
(rbar xmin xmax y if y==1,  horizontal barw(0.72) color("247 239 219") lcolor(none)) ///
(rcap ci_low ci_high y if type==1, horizontal lcolor("78 135 105") lwidth(medthick)) ///
(scatter y coef if type==1, msymbol(square) mcolor("78 135 105") msize(medium)) ///
(rcap ci_low ci_high y if type==2, horizontal lcolor("195 147 66") lwidth(medthick)) ///
(scatter y coef if type==2, msymbol(circle) mcolor("195 147 66") msize(medium)) ///
(scatter y labx if type==1, msymbol(none) mlabel(subgroup) mlabposition(9) mlabgap(0.2) mlabsize(small) mlabcolor("78 135 105")) ///
(scatter y labx if type==2, msymbol(none) mlabel(subgroup) mlabposition(9) mlabgap(0.2) mlabsize(small) mlabcolor("195 147 66")), ///
yscale(range(0.5 11.7)) ///
ylabel(10.5 "Organization" ///
       7.5  "Market access" ///
       4.5  "Region" ///
       1.5  "Governance", ///
       angle(0) labsize(small) noticks nogrid) ///
xlabel(-80(20)20, labsize(small) nogrid) ///
xscale(range(-100 20.5)) ///
xline(0, lcolor("160 160 160") lpattern(dash) lwidth(thin)) ///
xtitle("Agricultural carbon emissions", size(small)) ///
ytitle("") ///
title("b", size(large) position(11)) ///
legend(off) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
aspectratio(0.8) ///
name(fig5b, replace)


**************************************************
* Panel c: Producer income growth
**************************************************

clear
set more off

input str20 subgroup coef t y type
"Family farms"     16.27   39.69   11   1
"Cooperatives"     15.25   62.99   10   2
"Near"             15.52   73.22    8   1
"Far"              16.07   12.93    7   2
"Inland"           15.46   44.53    5   1
"Coastal"          15.61   59.52    4   2
"Non-pilot"        15.10   70.08    2   1
"Pilot"            17.81   25.23    1   2
end

gen se = abs(coef/t)
gen ci_low = coef - 1.96*se
gen ci_high = coef + 1.96*se

gen xmin = 13.5
gen xmax = 19.1
gen labx = 19.0

twoway ///
(rbar xmin xmax y if y==11, horizontal barw(0.72) color("236 231 247") lcolor(none)) ///
(rbar xmin xmax y if y==10, horizontal barw(0.72) color("246 231 225") lcolor(none)) ///
(rbar xmin xmax y if y==8,  horizontal barw(0.72) color("236 231 247") lcolor(none)) ///
(rbar xmin xmax y if y==7,  horizontal barw(0.72) color("246 231 225") lcolor(none)) ///
(rbar xmin xmax y if y==5,  horizontal barw(0.72) color("236 231 247") lcolor(none)) ///
(rbar xmin xmax y if y==4,  horizontal barw(0.72) color("246 231 225") lcolor(none)) ///
(rbar xmin xmax y if y==2,  horizontal barw(0.72) color("236 231 247") lcolor(none)) ///
(rbar xmin xmax y if y==1,  horizontal barw(0.72) color("246 231 225") lcolor(none)) ///
(rcap ci_low ci_high y if type==1, horizontal lcolor("113 96 162") lwidth(medthick)) ///
(scatter y coef if type==1, msymbol(square) mcolor("113 96 162") msize(medium)) ///
(rcap ci_low ci_high y if type==2, horizontal lcolor("201 111 84") lwidth(medthick)) ///
(scatter y coef if type==2, msymbol(circle) mcolor("201 111 84") msize(medium)) ///
(scatter y labx if type==1, msymbol(none) mlabel(subgroup) mlabposition(9) mlabgap(0.2) mlabsize(small) mlabcolor("113 96 162")) ///
(scatter y labx if type==2, msymbol(none) mlabel(subgroup) mlabposition(9) mlabgap(0.2) mlabsize(small) mlabcolor("201 111 84")), ///
yscale(range(0.5 11.7)) ///
ylabel(10.5 "Organization" ///
       7.5  "Market access" ///
       4.5  "Region" ///
       1.5  "Governance", ///
       angle(0) labsize(small) noticks nogrid) ///
xlabel(14(1)19, labsize(small) nogrid) ///
xscale(range(13.5 19.25)) ///
xtitle("Producer income growth", size(small)) ///
ytitle("") ///
title("c", size(large) position(11)) ///
legend(off) ///
graphregion(color(white)) ///
plotregion(color(white)) ///
aspectratio(0.8) ///
name(fig5c, replace)


**************************************************
* Combine panels
**************************************************

graph combine fig5a fig5b fig5c, ///
cols(3) ///
imargin(tiny) ///
graphregion(color(white)) ///
xsize(15) ///
ysize(6)

graph export "E:\学习\科研\产地冷库（undergoing)\相关数据\history处理记录\画图\Figure5_heterogeneity_final.png", replace