*model and data with only dummy
clear all

set obs 1000

gen hours = 100*runiform() //generating some random x variable that's uniformly distributed between 0,100
gen D = 1 in 1/500 
replace D = 0 if D == .
gen wages = 100+ 2*hours + D*100 + rnormal(0,10)
label define D 1 "High education" 0 "Low education"
label values D D
lab var wages "Wage (in $)"
lab var hours "Hours spent on YouTube"
*for the sake of a made up example: let's say slope is 2 and this is causal evidence what's the effect of youtube on wages for low education?
*high education?
*what's this gap then?
twoway (scatter wages hours if D == 1, mcolor(blue%20)) ///
(scatter wages hours if D == 0, mcolor(red%20)) ///
(lfit wages hours if D == 1, lcolor(black)) ///
(lfit wages hours if D == 0, lcolor(black)), ///
yscale(range(0 400) extend) ylabel(#5) name(dummod, replace) ///
legend(order(1 2) label(1 "High education") label(2 "Low education")) ///
ytitle("Wage (in $)")

* same thing but with regression eq
*low educ captured in intercept
*high educ captured in dummy coefficient
twoway (scatter wages hours if D == 1, mcolor(blue%20)) ///
(scatter wages hours if D == 0, mcolor(red%20)) ///
(lfit wages hours if D == 1, lcolor(black)) ///
(lfit wages hours if D == 0, lcolor(black)), ///
yscale(range(0 400) extend) ylabel(#5) name(dummod_withreg, replace) ///
legend(order(1 2) label(1 "High education") label(2 "Low education")) ///
ytitle("Wage (in $)") ///
title("wages{subscript:i} = {&alpha} + {&beta}{subscript:1}*Hours_YouTube{subscript:1{subscript:i}} + {&beta}{subscript:2}*High_Educ + {&epsilon}{subscript:i}", size(medium))


*two things are true:
* The effect of youtube on wages are the same for higher and lower education. Every hour of YouTube increases wage by 2 dollars
* Holding constant (or conditional on) hours spent on YouTube, people with higher education have greater wages than people who are less educated, on average. 

* mean difference
su wages if D == 1, det
local high = r(mean)
su wages if D == 0, det
local low = r(mean)

su hours, det
local hours_p25 = r(p25)
local hours_p75 = r(p75)
twoway (scatter wages hours if D == 1, mcolor(blue%20)) ///
(scatter wages hours if D == 0, mcolor(red%20)) ///
(function y = `high', lcolor(black%50) lpattern(dash) range(`hours_p25' `hours_p75')) ///
(function y = `low', lcolor(black%50) lpattern(dash) range(`hours_p25' `hours_p75')), ///
yscale(range(0 400) extend) ylabel(#5) name(dummod_meandiff, replace) ///
legend(order(1 2) label(1 "High education") label(2 "Low education")) ///
ytitle("Wage (in $)") xtitle("Hours spent on YouTube") ///
title("wages{subscript:i} = {&alpha} + {&beta}{subscript:1}*Hours{subscript:1{subscript:i}} + {&beta}{subscript:2}*Educ + {&epsilon}{subscript:i}", size(medium))

*==============================================================================
*==============================================================================
*==============================================================================
*==============================================================================

clear


set obs 1000

gen hours = 100*runiform() //generating some random x variable that's uniformly distributed between 0,100
gen D = 1 in 1/500 
replace D = 0 if D == .
gen wages = 100+ 2*hours + D*100 + 3*D*hours + rnormal(0,10)
label define D 1 "High education" 0 "Low education"
label values D D
lab var wages "Wage (in $)"
lab var hours "Hours spent on YouTube"


*in plain english, what's your analysis of this data? Show dummod on the side
twoway (scatter wages hours if D == 1, mcolor(blue%20)) ///
(scatter wages hours if D == 0, mcolor(red%20)) ///
(lfit wages hours if D == 1, lcolor(black)) ///
(lfit wages hours if D == 0, lcolor(black)) ///
(function y = 200 + 2*x, lpattern(dash) lcolor(red%50) range(hours)), ///
yscale(range(0 400) extend) ylabel(#5) name(dumint, replace) ///
legend(order(1 2) label(1 "High education") label(2 "Low education")) ///
ytitle("Wage (in $)")


twoway (scatter wages hours if D == 1, mcolor(blue%20)) ///
(scatter wages hours if D == 0, mcolor(red%20)) ///
(lfit wages hours if D == 1, lcolor(black)) ///
(lfit wages hours if D == 0, lcolor(black)) ///
(function y = 200 + 2*x, lpattern(dash) lcolor(red%50) range(hours)), ///
yscale(range(0 400) extend) ylabel(#5) name(dumint_withreg, replace) ///
legend(order(1 2) label(1 "High education") label(2 "Low education")) ///
ytitle("Wage (in $)") ///
title("wages{subscript:i} = {&alpha} + {&beta}{subscript:1}*Hours{subscript:1{subscript:i}} + {&beta}{subscript:2}*Educ + {&beta}{subscript:3}*Educ*Hours + {&epsilon}{subscript:i}", size(medsmall))

*y has some variance
*this regression is decomposing that variance into 3 parts:
*1. holding everything else constant, for every hour spent on youtube, wages increase by $2 on average
*2. holding everything constant, higher educated people earn $200 more than low educated people on average
*3. holding everything constant, higher educated people earn an extra $2 for every hour compared to low education people, on average.

* I can run two different regressions, one for high educ and one for low educ: it's the same as above. Their intercept is different and so are the slopes.

*called linear regression because linear in parameters (beta ^ 1)



*what happens if you forget to add the dummy?
*case 1: non-significant difference

*case 2: significant difference

*multivariate regression is a powerful tool to do same kind of descriptive analyses but with multiple variables at the same time. 
*regression (a tool) + logic/cleverness = you can get causal evidence