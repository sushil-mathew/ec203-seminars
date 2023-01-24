*model and data with only dummy
clear all

****************************************************
* IN THIS SECTION I'M GOING TO GENERATE MY OWN DATA
* Before and after each step, go to the main stata window and type "browse"
****************************************************
* let there be light!
*at this point in the code, the stata data area is completely empty
*the below line tells stata to set observations as 1000
set obs 1000 

*generating a new variable for hours of youtube watched. i'm going to call it "hours"
*runiform() randomly draws 1000 (because we set obs as 1000) values from a uniform distribution with a minimum value of 0 and maximum of 1
*I multiply each term obtained from this, by 100, so now it's as if I'm drawing from a uniform distribution with minimum value 0 and maximum of 100.

gen hours = 100*runiform() //generating some random x variable that's uniformly distributed between 0,100

*generating a dummy variable for high and low education. I'm going to call this "D" for dummy.
*We have set obs as 1000, this line tells stata to assign high education to the first 500 lines. The rest of the lines will be missing values, which Stata denotes as "."
gen Educ = 1 in 1/500 
*this is one way to assign 0 to remaining 500 observations
replace Educ = 0 if D == .

*I'm generating an error term. The error is a random number drawn from a normal distribution that has a mean of 0, and a sd of 10. This is what rnormal() does.
gen error_term = rnormal(0,10)

*here I'm going to generate the intercept, alpha_i
gen alpha_i = 100

*here I'm going to generate the slope beta_1
gen beta_1 = 2

*here I'm generating beta_2, which is the added wage for high education compared to low education, holding constant their hours 
gen beta_2 = 100

*I'm going to generate the y variable which is wages 
gen wages = alpha_i+ beta_1*hours + beta_2*Educ + error_term 

*I'm going to define value labels, for this dummy variable Educ. Whenever I display my data if Educ = 1, I want Stata to display "High Education" instead of the number, 1
label define Educ 1 "High education" 0 "Low education"
*assigning this value label to the variable Educ
label values Educ Educ

* now I'm going to label the variable itself. Go the stata main window and see the top right corner where the variables are shown. Here you can write a description of what the variables contain
lab var wages "Wage (in $)"
lab var hours "Hours spent on YouTube"

*******************************************************************************
* FINISHED GENERATING THIS HYPOTHETICAL DATA
*******************************************************************************


*******************************************************************************
* NOW VISUALISE THE DATA 
* So far we generated the data and designed it to look a certain way. This was just to learn how to use stata, and kind of live in a world where we perfectly know the data (imagine you're god).
* Now we're going to pretend like we're handing this data over to a data analyst somewhere, and they don't know the equation we used to generate this data. They have to use some logic about the relationship between wage, hours and education to come up with a good model.
* Such a person would perhaps try to visualise the data in different ways before they develop a good model.
*******************************************************************************

*Let's visualise this data so that we can conduct some useful analysis on it.

* The below lines are to make a scatter plot (a plot with an x and y axis, and each point representing the respective x and y), and overlap that with a line drawn through it (using the lfit command). Stata fits this line through OLS.

/*
There's a lot going on, so let me try to describe what's happening 
the "///" is here to tell stata that the command is not over, and that it continues to the next line
twoway is a "family" of graphs that have an x and y axis. Type "help twoway" in the main Stata window to see the different types.
Notice that the commands are written like 
twoway (scatter y x if <some condition>, some options)(scatter y x if <some other condition>, some options)(lfit y x if <some conditions>, some options) etc.

These parentheses are telling stata to overlay a lot of these different twoway style graphs on top of each other.

mcolor(blue%20) means: mcolor - marker colour. marker as in, the points on a scatter plot is called a marker. blue%20 - use blue colour with 80% (=100-20) transparency.

yscale(range(0 400) extend): define the range (min and max values) of the y axis as 0 to 400. Extend means draw the axis line extending to 0. The default is for Stata to start at 100 for the y-axis (because our data starts at a 100). 
ylabel(#5) tells stata to draw 5 labels on the y axis, nicely spaced out from each other.
name(dummod, replace): name this graph output as "dummod" (dummy model - I just made this up). replace tells stata to replace this if there's already a graph called dummod in stata memory. If I don't do this, Stata just calls this "Graph", and "Graph" gets replaced if I run another command.
legend(order(1 2) label(1 "High education") label(2 "Low education")) - 
legend: add a legend
order(1 2): add a legend only for scatter if Educ == 1 and Educ ==0. Also order it as high education first, then low education. I don't want a legend for the lines, because I already know what they mean 
label(1 "High education"): in the legend name the first set of points as high education. Similarly for low education 
ytitle("Wage (in $)"): Write the title for the y axis on the plot, so that everyone can see
Same for x title
*/
twoway (scatter wages hours if Educ == 1, mcolor(blue%20)) /// 
(scatter wages hours if Educ == 0, mcolor(red%20)) ///
(lfit wages hours if Educ == 1, lcolor(black)) ///
(lfit wages hours if Educ == 0, lcolor(black)), ///
yscale(range(0 400) extend) ylabel(#5) name(dummod, replace) ///
legend(order(1 2) label(1 "High education") label(2 "Low education")) ///
ytitle("Wage (in $)") xtitle("Hours spent on YouTube")



* Having seen the data I think a good regression model would be whatever I wrote in the title() section of the below code block. See here for more info on what these bits mean: https://www.stata.com/bookstore/pdf/g_text.pdf
twoway (scatter wages hours if D == 1, mcolor(blue%20)) ///
(scatter wages hours if D == 0, mcolor(red%20)) ///
(lfit wages hours if D == 1, lcolor(black)) ///
(lfit wages hours if D == 0, lcolor(black)), ///
yscale(range(0 400) extend) ylabel(#5) name(dummod_withreg, replace) ///
legend(order(1 2) label(1 "High education") label(2 "Low education")) ///
ytitle("Wage (in $)") ///
title("wages{subscript:i} = {&alpha} + {&beta}{subscript:1}*Hours{subscript:1{subscript:i}} + {&beta}{subscript:2}*Educ + {&epsilon}{subscript:i}", size(medium))

 

* For educ = 1 (high educ) & 0 (low), what's the mean, median, and different percentiles, the 4 smallest values, the 4 largest values etc. for wages
*det is short for "detail" and asks stata to output all these little details
su wages if Educ == 1, det
*local is a temporary variable. You won't see it in the main variable window on your main Stata screen. That's just how it works. It's useful because it takes up only one spot in the computer memory. As opposed say, beta_1 which I created above - which takes up 1000 spots in memory. This is very useful sometimes when you deal with large data. I use these later when I produce a plot below.
local high = r(mean)
su wages if Educ == 0, det
local low = r(mean)

*does the same as above but produces a smaller table
bys Educ: su wages 

su wages, det
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
* NEW DATA BEING GENERATED
*==============================================================================
*==============================================================================
*==============================================================================
*==============================================================================

clear


set obs 1000

gen hours = 100*runiform()
gen Educ = 1 in 1/500 
replace Educ = 0 if Educ == .
gen wages = 100+ 2*hours + Educ*100 + 3*D*hours + rnormal(0,10)
label define Educ 1 "High education" 0 "Low education"
label values Educ Educ
lab var wages "Wage (in $)"
lab var hours "Hours spent on YouTube"


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

twoway (scatter wages hours if D == 1, mcolor(blue%20)) ///
(scatter wages hours if D == 0, mcolor(red%20)) ///
(lfit wages hours if D == 1, lcolor(black)) ///
(lfit wages hours if D == 0, lcolor(black)) ///
(function y = 200 + 2*x, lpattern(dash) lcolor(red%50) range(hours)), ///
yscale(range(0 400) extend) ylabel(#5) name(dumint_withreg1, replace) ///
legend(order(1 2) label(1 "High education") label(2 "Low education")) ///
ytitle("Wage (in $)") ///
title("High educ: wages{subscript:i} = {&alpha} + {&beta}{subscript:1}*Hours{subscript:1{subscript:i}} + {&beta}{subscript:2}*1 + {&beta}{subscript:3}*1*Hours + {&epsilon}{subscript:i}""Low educ: wages{subscript:i} = {&alpha} + {&beta}{subscript:1}*Hours{subscript:1{subscript:i}} + {&beta}{subscript:2}*0 + {&beta}{subscript:3}*0*Hours + {&epsilon}{subscript:i}", size(small))

twoway (scatter wages hours if D == 1, mcolor(blue%20)) ///
(scatter wages hours if D == 0, mcolor(red%20)) ///
(lfit wages hours if D == 1, lcolor(black)) ///
(lfit wages hours if D == 0, lcolor(black)) ///
(function y = 200 + 2*x, lpattern(dash) lcolor(red%50) range(hours)), ///
yscale(range(0 400) extend) ylabel(#5) name(dumint_withreg2, replace) ///
legend(order(1 2) label(1 "High education") label(2 "Low education")) ///
ytitle("Wage (in $)") ///
title("Two regressions" "Only for high education sample: wages{subscript:i} = {&alpha} + {&beta}{subscript:1}*Hours{subscript:1{subscript:i}} + {&epsilon}{subscript:i}""Only for low education sample: wages{subscript:i} = {&alpha} + {&beta}{subscript:1}*Hours{subscript:1{subscript:i}} + {&epsilon}{subscript:i}", size(small))

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


twoway (scatter wages hours if D == 1, mcolor(blue%20)) ///
(scatter wages hours if D == 0, mcolor(red%20)) ///
(lfit wages hours) ///
(function y = 200 + 2*x, lpattern(dash) lcolor(red%50) range(hours)), ///
yscale(range(0 400) extend) ylabel(#5) name(dum_forgot, replace) ///
legend(order(1 2) label(1 "High education") label(2 "Low education")) ///
ytitle("Wage (in $)")


*case 2: significant difference

*multivariate regression is a powerful tool to do same kind of descriptive analyses, with multiple variables at the same time. 
*regression (a tool) + logic/cleverness = you can get causal evidence