*this file doesn't have much comments compared to last time. That's because the things I'm doing are very similar to the last time. And the overview.do file from the ps9 folder has more detailed information.
*if you run into errors, please email me on sushil.mathew.1@warwick.ac.uk

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

*Just generating some random data
set obs 10000 
gen D = 1 in 1/5000
replace D = 0 in 5001/10000
gen y = 1 in 1/25
replace y = 1 in 4001/10000
replace y = 0 if y == .
replace y = 0 in 9750/10000

bys D y: gen weight = _N //I produce some graphs below. In those, for ex: if there are 99 people with x= 1 and 1 person with x=0, I want the graph to reflect this difference. So I want to generate "weights" for this purpose
replace weight = weight*3.9 if weight < 1000 //The way stata draws the size of the bubbles in the scatter plot below is quite awkward. There's no theory behind what I'm doing in this step. I'm just manually manipulating the weights, so that you can actually see the relative difference in bubble size. To understand what I mean: browse the data before this step, and experiment with different weights before you plot this data
replace weight = weight*3 if weight > 1000
replace weight = weight*3 if weight > 3000

*make a scatter plot. aw stands for analytic weights. Stata has different kind of weights. These are difficult to explain at this stage, but you'll learn what it is, as you gain experience working with different kinds of data.
*The way I've constructed this graph is very similar to what I had done last week in the ps9/overview.do file, and I've written more detailed comments there.
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


clear
set obs 100
gen x = _n 
gen y = 0 in 1/50
replace y=1 in 51/100

twoway (scatter y x, mcolor(black%50))(lfit y x), ///
name(outsidebounds, replace) ytitle("Y") xtitle("X") ///
legend(off)
	
*heteroskedasticity: problem (copy the link below and paste it into your browser)
*https://twitter.com/i/status/1590366298114265089
/*
in this GIF, imagine the grey dots to be the population data (so for ex: the data on all cars in the UK)
imagine the red dots to be a random sample of cars that you pick for your study (it's too expensive and impractical to collect data on all the cars in the UK). The red dots are changing to reflect the "randomness" of picking a sample. If you picked a sample on Jan 30, 2023 you'd pick the first set of red dots in the animation. If you picked a sample at a different time on the same day, you'd pick a completely different sample. In practice, people tend to draw only one sample. But still, in theory, we want to make sure that the slope we get from the regression remains stable to different "picks" of the data.

The distance between the grey dots and the line (showing the relationship between x and y) is called the "error"
The distance between the red dots and the line corresponding to each each of red dots is called the "residual".
It's very important to know the distinction between both these terms, even though the idea behind them are very similar. Error is for the population, residual is for the sample.
you see 4 panels here: Left-Top, Left-Bottom, Right-top, Right-bottom
Focus only on Left-Top and bottom first: you will notice 2 things
	(a) In the population data, as x increases, the variance in the error term changes.
	(b) In the left-bottom panel, each time you draw a sample of cars, the slope of the x-y relationship is more or less the same on average, for all practical purposes.
Now focus on the Right-top and bottom:
	(a) In the population data, as x increases, the variance in the error term increases. As a consequence, the variance in the residual also increases.
	(b) In the right bottom panel: each time you draw a sample of cars, the slope of the x-y relationship:
		(i) doesn't necessarily reflect the "true" slope
		(ii) but if you average all the slopes, you get the true slope. But still, the fact that the slope itself could be wildly negative, and wildly positive, induces so much uncertainty. We end up having large variation in the slope itself. We don't want this. If we pick a random sample, we would want this estimated value of the slope to be quite close to the true slope. So how do we solve this problem? See answer below.
		
*/
*heteroskedasticity: solution -
* account for these different variances of the error term (the error can be approximated with the residual). That is, tell the computer to expect that there will be different variances in the error term for each value of x, and account for it in the way it calculates the slope. The exact mechanism of how it's accounted for has some heavy theory behind it - you've seen a preview in your lectures, but if you're really interested we can discuss this during office hours.
*How do you tell the computer to expect different variances? The answer to this is in your problem set where you're asked to find the heteroskedasticity-robust standard errors. 
