# Scientific Reports code package (review draft)

These Stata do-files document the analysis workflow used for the manuscript. They are an adapted public-facing code package, not byte-for-byte copies of the local scripts. They do not contain study data or model outputs.

## Files

1. `00_setup.do`: edit the project root and check optional Stata commands.
2. `01_construct_outcomes.do`: construct individual outcomes from analysis-ready input.
3. `02_baseline.do`: individual OLS and county panel fixed-effects models.
4. `03_heterogeneity.do`: subgroup regressions and interaction tests.
5. `04_matched_income.do`: paired-sample income models.
6. `05_effect_figures.do`: coefficient plots from the baseline models.

Run `00_setup.do` from Stata after setting `project_root` in that file. The analysis files expect `data/individual_analysis.dta`, `data/county_panel.dta`, and `data/matched_pairs.dta`; `01_construct_outcomes.do` additionally expects `data/individual_raw.dta`. These datasets are **not included**. The figures script requires the models from `02_baseline.do` to be stored in the same Stata session. It plots baseline coefficients from stored estimates, not the exact submitted artwork.

Variable names in this package mirror the local analysis data. Readers need lawful access to suitable data to execute it. No claim of independent end-to-end reproduction is made until the adapted files are run against an approved release dataset. The original analysis also used Python for data matching and accumulation and separate map artwork; those inputs and scripts are not represented as reproducible here.

Before GitHub publication, review the code and this README against the final manuscript, confirm the analysis definitions and figure numbers, and choose a license. Do not upload the local `.dta`, spreadsheets, logs, RTF results, map data, API keys, or project notes without separate review.
