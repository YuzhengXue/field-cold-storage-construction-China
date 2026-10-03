* Baseline models: loss, income, and county agricultural carbon emissions.
version 18
set more off
local individual_controls distance_to_gov county_gdp_per_capita ///
    county_agri_value_added county_crop_sown_area ///
    county_primary_employment county_agri_machinery
local county_controls county_gdp_per_capita county_agri_value_added ///
    county_crop_sown_area county_primary_employment county_agri_machinery

use "${data_dir}/individual_analysis.dta", clear
foreach outcome in loss_reduction income_growth {
    local prefix = cond("`outcome'"=="loss_reduction", "loss", "income")
    foreach exposure in csc amount capacity {
        regress `outcome' `exposure' `individual_controls', vce(cluster county_code)
        estimates store `prefix'_`exposure'
    }
    esttab `prefix'_csc `prefix'_amount `prefix'_capacity ///
        using "${output_dir}/`prefix'_baseline.rtf", replace ///
        b(6) se(6) star(* 0.10 ** 0.05 *** 0.01) ///
        stats(N N_clust r2, fmt(0 0 4))
}

use "${data_dir}/county_panel.dta", clear
xtset county_code year
foreach exposure in csc_accum amount_accum capacity_accum {
    xtreg county_agri_carbon `exposure' `county_controls' i.year, ///
        fe vce(cluster county_code)
    estimates store carbon_`exposure'
}
esttab carbon_csc_accum carbon_amount_accum carbon_capacity_accum ///
    using "${output_dir}/carbon_baseline.rtf", replace ///
    b(6) se(6) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N N_g r2_w, fmt(0 0 4))
