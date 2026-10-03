* Compact coefficient plots based on the models stored by 02 and 04.
* Run in the same Stata session after both scripts. This illustrates the
* figure workflow; manuscript artwork may have additional styling.
version 18
set more off
tempfile effects
tempname handle
postfile `handle' str12 panel str36 exposure double coefficient se ///
    byte row using `effects', replace

foreach outcome in loss income carbon {
    if "`outcome'" == "carbon" {
        local variables csc_accum amount_accum capacity_accum
    }
    else {
        local variables csc amount capacity
    }
    local row = 3
    foreach variable of local variables {
        estimates restore `outcome'_`variable'
        local scale = 1
        if "`variable'" == "csc_accum" local scale = 0.1
        if inlist("`variable'", "capacity", "capacity_accum") local scale = 100
        post `handle' ("`outcome'") ("`variable'") ///
            (_b[`variable']*`scale') (_se[`variable']*`scale') (`row')
        local row = `row' - 1
    }
}
postclose `handle'
use `effects', clear
generate double ci_low = coefficient - invnormal(.975)*se
generate double ci_high = coefficient + invnormal(.975)*se
label define exposure_rows 3 "Construction" 2 "Number of facilities" ///
    1 "Storage capacity", replace
label values row exposure_rows

foreach outcome in loss income carbon {
    twoway (rcap ci_low ci_high row if panel=="`outcome'", horizontal) ///
        (scatter row coefficient if panel=="`outcome'", ///
        msymbol(circle)), ///
        ylabel(1/3, valuelabel angle(0)) ytitle("") ///
        xtitle("Estimated effect (manuscript units)") ///
        legend(off) graphregion(color(white))
    graph export "${output_dir}/`outcome'_effects.png", replace width(2400)
}

* Income matched estimates can be plotted by applying the same postfile
* pattern to matched_treat, matched_num_storage_d1, and matched_capacity_d1.
