* Illustrative construction of individual outcomes from an approved input.
* Input variable names follow the original analysis; data are not distributed.
version 18
set more off
use "${data_dir}/individual_raw.dta", clear

generate double loss_reduction = .
replace loss_reduction = loss_ratio_d0 - loss_ratio_d1 if !missing(loss_ratio_d1)
replace loss_reduction = loss_ratio_d0 - loss_ratio_d2 if !missing(loss_ratio_d2)
replace loss_reduction = 0 if missing(loss_reduction)

generate double income_growth = .
replace income_growth = income_increase_d1 if !missing(income_increase_d1)
replace income_growth = income_increase_d2 if !missing(income_increase_d2)
replace income_growth = 0 if missing(income_growth)

* The second follow-up takes precedence if both are observed. Verify this
* coding rule and the zero replacement against the final study protocol.
save "${data_dir}/individual_analysis.dta", replace
