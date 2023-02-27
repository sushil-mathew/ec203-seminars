*rdd overview

*generate fake data
clear all
set obs 200

gen x = _n 
gen T = 1 if x>100
replace T = 0 if x <= 100
gen a = 2
gen b1 = 1
gen b2 = 90
gen errorterm = rnormal(0,10)
gen y = a + b1*x + b2*T + errorterm

*make plots 
scatter y x, xline(100, lcolor(red)) mcolor(black%80) ///
xtitle("X", size(large)) ///
ytitle("Y", size(large)) 

*either side of threshold can be treatment
twoway (scatter y x if T == 1, mcolor(black%20))(scatter y x if T == 0, mcolor(black%80)), ///
xline(100, lcolor(red))  ///
xtitle("X", size(large)) ytitle("Y", size(large)) ///
legend(off)

*either side of threshold can be treatment
twoway (scatter y x if T == 1, mcolor(black%80))(scatter y x if T == 0, mcolor(black%20)), ///
xline(100, lcolor(red))  ///
xtitle("X", size(large)) ytitle("Y", size(large)) ///
legend(off)

*bad rd
clear all
set obs 200

gen x = _n 
gen T = 1 if x>100
replace T = 0 if x <= 100
gen a = 4900
gen b1 = 140
gen b2 = -1
gen errorterm1 = rnormal(0,1000)
gen errorterm2 = rnormal(0,5000)
gen y = a + b1*x + b2*x^2 + errorterm1 if x <= 100
replace y = a + b1*x + 1*x^2 +errorterm2 if x > 100

gen lny = ln(y)

twoway (scatter lny x if T == 1, mcolor(black%80))(scatter lny x if T == 0, mcolor(black%80)), ///
xline(100, lcolor(red)) ///
xtitle("Firm income", size(large)) ytitle("Firm productivity", size(large)) ///
legend(off)