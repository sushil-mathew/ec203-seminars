cd "$dropbox/TA/EC203/Term 2/class13"

import delimited avocado, clear

graph set window fontface "Times New Roman"
gen vol_in_mil = totalvolume/(10)^6

twoway (scatter averageprice vol_in_mil, mfcolor(sandb%60) mlcolor(dkgreen%80) msize(vlarge) mlwidth(medthick)) ///
(scatter averageprice vol_in_mil, mcolor(brown%90) msize(medsmall)), legend(off) ///
xtitle("Number of avocado's sold (in millions)") ytitle("Average avocado price ($)") ///
ylabel(, nogrid) xlabel(, nogrid)
graph export avocado_p_vs_q.png, replace
