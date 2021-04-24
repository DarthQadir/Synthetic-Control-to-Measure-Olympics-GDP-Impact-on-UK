* import data
import delimited https://raw.githubusercontent.com/DarthQadir/Synthetic-Control-to-Measure-Olympics-GDP-Impact-on-UK/main/dataset_uk.csv

* Generate country no. for panel data
gen countryno = .
replace countryno = 1 if country == "United Kingdom"
replace countryno = 2 if country == "Germany"
replace countryno = 3 if country == "Italy"
replace countryno = 4 if country == "France"

* Use log of gdp
gen log_gdp = log(gdp)

* Tell Stata we are using panel data
xtset countryno year



* Code for 2012 treatment plot and the synthetic control method
synth log_gdp log_gdp(2011) log_gdp(2008) log_gdp(2001) expenditure population gdp_cap inflation enrollment export import, trunit(1) trperiod(2012) xperiod(2001(1)2011) mspeperiod(2001(1)2011) resultsperiod (2001(1)2016) fig


* Preserve data in case we need to restore it later
preserve

* Code to calculate the gaps between the synthetic control of Brazil and Brazil itself
matrix a =  e(Y_treated) - e(Y_synthetic)
svmat double a, name(gap)
keep gap year
drop if gap==.

* Make plot for the gaps
twoway line gap year, yline(0, lpattern(shortdash) lcolor(black)) xline(1990, lpattern(shortdash) lcolor(black)) xtitle("Year",size(medsmall)) xlabel(#10) ytitle("Log GDP Gap", size(medsmall))

* Restore dataset
restore

* Code for 2013 treatment plot and the synthetic control method
synth log_gdp log_gdp(2012) log_gdp(2008) log_gdp(2001) expenditure population gdp_cap inflation enrollment export import, trunit(1) trperiod(2013) xperiod(2001(1)2012) mspeperiod(2001(1)2012) resultsperiod (2001(1)2016) fig

* Code for France placebo plot and the synthetic control method
synth log_gdp log_gdp(2011) log_gdp(2008) log_gdp(2001) expenditure population gdp_cap inflation enrollment export import, trunit(4) trperiod(2012) xperiod(2001(1)2011) mspeperiod(2001(1)2011) resultsperiod (2001(1)2016) fig


