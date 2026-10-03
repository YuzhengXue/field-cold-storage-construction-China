* Matched-pair income analysis. The matching procedure/data are not included.
version 18
set more off
use "${data_dir}/matched_pairs.dta", clear

generate byte treat = storage_d1
generate double income_increase = .
replace income_increase = income_increase_d1 if !missing(income_increase_d1)
replace income_increase = income_increase_d2 if !missing(income_increase_d2)
replace income_increase = 0 if missing(income_increase)

foreach exposure in treat num_storage_d1 capacity_d1 {
    reghdfe income_increase `exposure', absorb(pair_id) vce(cluster pair_id)
    estimates store matched_`exposure'
}
esttab matched_treat matched_num_storage_d1 matched_capacity_d1 ///
    using "${output_dir}/matched_income.rtf", replace ///
    b(6) se(6) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N N_clust r2, fmt(0 0 4))
