* Subgroup regressions and formal interaction tests.
* Inputs should contain approved, non-identifying 0/1 subgroup indicators:
* organization_group, far_distance, terrain_group, pilot_group.
* Pilot-county membership lists and geographic identifiers are not distributed.
version 18
set more off
local individual_controls distance_to_gov county_gdp_per_capita ///
    county_agri_value_added county_crop_sown_area ///
    county_primary_employment county_agri_machinery
local county_controls county_gdp_per_capita county_agri_value_added ///
    county_crop_sown_area county_primary_employment county_agri_machinery
local groups organization_group far_distance terrain_group pilot_group

use "${data_dir}/individual_analysis.dta", clear
foreach outcome in loss_reduction income_growth {
    local prefix = cond("`outcome'"=="loss_reduction", "loss", "income")
    foreach group of local groups {
        local short = cond("`group'"=="organization_group", "org", cond("`group'"=="far_distance", "dist", cond("`group'"=="terrain_group", "terrain", "pilot")))
        forvalues level = 0/1 {
            regress `outcome' csc `individual_controls' if `group'==`level', ///
                vce(cluster county_code)
            estimates store `prefix'_`short'_`level'
        }
        regress `outcome' c.csc##i.`group' `individual_controls' ///
            if inlist(`group',0,1), vce(cluster county_code)
        test 1.`group'#c.csc
        local interaction_p = r(p)
        estadd scalar P_interaction = `interaction_p'
        estimates store `prefix'_int_`short'
    }
    esttab `prefix'_org_0 `prefix'_org_1 ///
        `prefix'_dist_0 `prefix'_dist_1 ///
        `prefix'_terrain_0 `prefix'_terrain_1 ///
        `prefix'_pilot_0 `prefix'_pilot_1 ///
        using "${output_dir}/`prefix'_subgroups.rtf", replace ///
        keep(csc) b(6) se(6) stats(N N_clust r2, fmt(0 0 4))
    esttab `prefix'_int_org ///
        `prefix'_int_dist ///
        `prefix'_int_terrain ///
        `prefix'_int_pilot ///
        using "${output_dir}/`prefix'_interactions.rtf", replace ///
        b(6) se(6) stats(N N_clust r2 P_interaction, fmt(0 0 4 4))
}

* County-level group indicators should already be attached to the approved
* panel. In the local analysis, organization and distance groups were derived
* by aggregating individual records to county level before the panel merge.
use "${data_dir}/county_panel.dta", clear
xtset county_code year
foreach group of local groups {
    local short = cond("`group'"=="organization_group", "org", cond("`group'"=="far_distance", "dist", cond("`group'"=="terrain_group", "terrain", "pilot")))
    forvalues level = 0/1 {
        xtreg county_agri_carbon csc_accum `county_controls' i.year ///
            if `group'==`level', fe vce(cluster county_code)
        estimates store carbon_`short'_`level'
    }
    xtreg county_agri_carbon c.csc_accum##i.`group' ///
        `county_controls' i.year if inlist(`group',0,1), ///
        fe vce(cluster county_code)
    test 1.`group'#c.csc_accum
    local interaction_p = r(p)
    estadd scalar P_interaction = `interaction_p'
    estimates store carbon_int_`short'
}
esttab carbon_org_0 carbon_org_1 ///
    carbon_dist_0 carbon_dist_1 ///
    carbon_terrain_0 carbon_terrain_1 ///
    carbon_pilot_0 carbon_pilot_1 ///
    using "${output_dir}/carbon_subgroups.rtf", replace ///
    keep(csc_accum) b(6) se(6) stats(N N_g r2_w, fmt(0 0 4))
esttab carbon_int_org ///
    carbon_int_dist ///
    carbon_int_terrain ///
    carbon_int_pilot ///
    using "${output_dir}/carbon_interactions.rtf", replace ///
    b(6) se(6) stats(N N_g r2_w P_interaction, fmt(0 0 4 4))

