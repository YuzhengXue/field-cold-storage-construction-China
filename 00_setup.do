* Public-facing Stata setup. Edit only this path for your own data location.
version 18
set more off
global project_root "C:/path/to/approved_project"
global data_dir "${project_root}/data"
global output_dir "${project_root}/outputs"
capture mkdir "${output_dir}"

* esttab/estadd: SSC package estout; reghdfe: SSC package reghdfe.
capture which esttab
if _rc display as error "Install estout before running the table scripts."
capture which reghdfe
if _rc display as error "Install reghdfe before running matched-pair models."
