
clear all 

/*
********************
*SETUP
********************
*This part installs additional packages that are written by users to enhance the functioning of Stata.
*Here I'm going to run some packages to make the graphs look nice (the default stata graphs are pretty ugly IMO)
*If you need to run this section (it's not compulsory), remove the "/* at the top of this code block and the "*/" at the bottom of the code block.
ssc install color_style, replace
net install palettes , replace from("https://raw.githubusercontent.com/benjann/palettes/master/")
net install colrspace, replace from("https://raw.githubusercontent.com/benjann/colrspace/master/")
ssc install grstyle, replace

set scheme white, permanently //this will change the stata graph background from the dull blue to white permanently - that is, until you type this command again to change it to something else
*/

set obs 10000 
gen D = 1 in 1/5000
replace D = 0 in 5001/10000
gen y = 1 in 1/25
replace y = 1 in 4001/10000
replace y = 0 if y == .
replace y = 0 in 9750/10000

bys D y: gen weight = _N
replace weight = weight*3.9 if weight < 1000
replace weight = weight*3 if weight > 1000
replace weight = weight*3 if weight > 3000
scatter y D [aw=weight], mcolor(%20) ///
ylabel(-0.25 " " 0 1 1.25 " ") xlabel(-0.25 " " 0 1 1.25 " ") yscale(extend) ///
ytitle("A dummy variable", size(medium)) xtitle("Another dummy variable", size(medium)) ///
name(slr_dummy, replace) 


su y if D == 0
local ymean_0 = r(mean)
su y if D == 1
local ymean_1 = r(mean)
twoway (scatter y D [aw=weight]) ///
(function y = `ymean_0', lcolor(green) lpattern(dash) range(-0.2 0.2)) ///
(function y = `ymean_1', lcolor(green) lpattern(dash) range(0.8 1.2)), ///
ylabel(-0.25 " " 0 1 1.25 " ") xlabel(-0.25 " " 0 1 1.25 " ") yscale(extend) ///
ytitle("A dummy variable", size(medium)) xtitle("Another dummy variable", size(medium)) ///
name(slr_dummy_wmeans, replace) legend(off)

twoway (scatter y D [aw=weight]) ///
(function y = `ymean_0', lcolor(green) lpattern(dash) range(-0.2 0.2)) ///
(function y = `ymean_1', lcolor(green) lpattern(dash) range(0.8 1.2)), ///
ylabel(-0.25 " " 0 1 1.25 " ") xlabel(-0.25 " " 0 1 1.25 " ") yscale(extend) ///
name(slr_dummy_wmeans_reg, replace) legend(off) ///
ytitle("{bf:y}: Dummy {bf:dependent} variable", size(medium)) xtitle("{bf:D}: Dummy {bf:right-hand-side} variable", size(medium)) ///
title("(Surprise!) There's a regression for that" "y{subscript:i} = {&alpha} + {&beta}{subscript:1}*D{subscript:i} + {&epsilon}{subscript:i} where y = 0 or = 1.")


clear
set obs 100
gen x = _n
gen p = 0.1 if x <= 10
forval xloop=10(10)90{
	replace p = (`xloop' + 10)/100 if x > `xloop' & x < `xloop' + 11
}
gen y = 1 in 1
replace y = 0 if y == . & x <= 10
forval xloop=10(10)90{
	local endloop = `xloop'-1+(`xloop' + 10)/10
	replace y = 1 in `xloop'/`endloop'
}
replace y= 0 if y == .
replace y=1 in 100
twoway (scatter y x, mcolor(black%80) msize(small)) ///
(line p x), legend(off) ///
xtitle("x:	A continuous right-hand-side variable", size(medium)) ytitle("y:	A dummy dependent variable", size(medium)) ///
name(towards_lpm, replace)

quietly reg y x
predict yhat
su yhat 
local minyhat = r(min)
local maxyhat = r(max)
twoway (scatter y x, mcolor(black%80) msize(small)) ///
(line p x) ///
(lfit y x), legend(off) ///
xtitle("x:	A continuous right-hand-side variable", size(medium)) ytitle("y:	A dummy dependent variable", size(medium)) ///
title("Regression: y{subscript:i} = {&alpha} + {&beta}{subscript:1}*x{subscript:i} + {&epsilon}{subscript:i} where y = 0 or = 1.") ///
yscale(range(`minyhat' `maxyhat') extend) xscale() ///
name(lpm, replace)

*what's the least and highest predicted value of y in lpm?

clear
set obs 100
gen x = _n 
gen y = 0 in 1/50
replace y=1 in 51/100

twoway (scatter y x, mcolor(black%50))(lfit y x), ///
name(outsidebounds, replace) ytitle("Y") xtitle("X") ///
legend(off)
	
*heteroskedasticity: problem
