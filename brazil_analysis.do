* Import data
import delimited https://raw.githubusercontent.com/DarthQadir/Synthetic-Control-to-Measure-Olympics-GDP-Impact-on-UK/main/dataset_brazil.csv

* Generate country numbers for panel data
gen countryno = .
replace countryno = 1 if country == "Brazil"
replace countryno = 2 if country == "Peru"
replace countryno = 3 if country == "Colombia"
replace countryno = 4 if country == "Ecuador"
replace countryno = 5 if country == "Argentina"
replace countryno = 6 if country == "Paraguay"

* Tell Stata we are using panel data
xtset countryno year

* Generate log of gdp variable
gen log_gdp = log(gdp)

* Code to generate plot for brazil and carry out the synthetic control method
synth log_gdp log_gdp(2015) log_gdp(2010) log_gdp(2005) expenditure population gdp_cap inflation enrollment export import, trunit(1) trperiod(2016) xperiod(2005(1)2015) mspeperiod(2005(1)2015) resultsperiod (2005(1)2019) fig

* Preserve data in case we need to restore it later
preserve

* Code to calculate the gaps between the synthetic control of Brazil and Brazil itself
matrix a =  e(Y_treated) - e(Y_synthetic)
svmat double a, name(gap)
keep gap year
drop if gap==.

* Make plot for the gaps
twoway line gap year, yline(0, lpattern(shortdash) lcolor(black)) xline(1990, lpattern(shortdash) lcolor(black)) xtitle("Year",size(medsmall)) xlabel(#10) ytitle("Log GDP Gap", size(medsmall))