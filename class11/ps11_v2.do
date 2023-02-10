clear 

/********************************************************************************
							TABLE OF CONTENTS
--------------------------------------------------------------------------------	
	1. Plots showing different data for different R^2
	2. Actual problem set - how education drives wages
		a. Code Setup/Housekeeping
		b. Exploring variables
		c. Correcting some data errors
		d. Some dumb regressions (and why they're dumb)
		e. Generating new variables
		f. Some more regressions and comments on each
		g. Final thoughts on modelling
*/

**********************************************************************************************************************************************
**********************************************************************************************************************************************

*******************************************************************************
*******************************************************************************
*		1. Plots showing different data for different R^2
*******************************************************************************
/* SECTION DESCRIPTION
I'm generating my own data here, and I'm going to visualize this data to get you
thinking about R^2, standard errors, and a bunch of other stuff, that are related,
but often quite confusing.

1a. Generate data
1b. Generate plots
1c. Notes based on plots.
*/
*******************************************************************************

*****************************************
*1a. Generate data
/*
The data that I'm going to generate contains wages, hours spent on youtube, education and gender.
This is for illustration purposes only and doesn't reflect reality in any way. 
In this made-up data:
(a) Hours spent on youtube (called "hours" from now) has a +ve effect on wages. 
(b) Gender and hours are not correlated, i.e., if I tell you that someone spends a lot of time on youtube, you wouldn't be able to predict their gender, and vice versa.
(c) Gender is exogenous to wages. Exogeneity means many things. In this case it means: wages do not cause gender; gender and wages don't have a common factor causing them (jargon-y way to say this: gender and wages are not confounded by a third factor). 
(d) Education and hours are not correlated, i.e. if I tell you that someone spends a lot of time on youtube, you wouldn't be able to predict their education, and vice versa
(e) Education and gender are not correlated, i.e., if I tell you that someone has high or low education, you wouldn't be able to predict their gender with any degree of confidence, and vice versa.

Convince yourself that you see these facts in the data visualisations from the next section. 
*/
*****************************************

set obs 1000 
gen hours = 100*runiform() //generating some random x variable that's uniformly distributed between 0,100

gen Educ = 1 in 1/500 
replace Educ = 0 if Educ == .

gen error_term = rnormal(0,10)

gen alpha_i = 100

gen beta_1 = 2

gen beta_2 = 100

gen wages = alpha_i+ beta_1*hours + beta_2*Educ + error_term 

*I'm going to define value labels, for this dummy variable Educ. Whenever I display my data if Educ = 1, I want Stata to display "High Education" instead of the number, 1
label define Educ 1 "High education" 0 "Low education"
*assigning this value label to the variable Educ
label values Educ Educ

* now I'm going to label the variable itself. Go the stata main window and see the top right corner where the variables are shown. Here you can write a description of what the variables contain
lab var wages "Wage (in $)"
lab var hours "Hours spent on YouTube"

* I'm doing i.Educ, because that's how I tell stata that educ is a dummy variable that takes the value 0 and 1. 
* I'm doing c.hours because that's how I tell stata that hours is a continuous variable.
* read more about stata regressions by typing: "help regress" (without the speech marks) on the stata main window
* I don't need to put i. or c. for the y variable (wages). You can think about why this is the case. If you still don't get it, please do get in touch, and I'd be happy to talk about it. 
reg wages c.hours i.Educ 
* I'm asking stata to create a variable called "bestfit" that contains the prediction from the above regression.
predict bestfit

* generating a dummy for gender. Please remember that there is no real economic meaning to these variables, I'm just randomly creating them, so that the data look a certain way and we can think about what a regression is. 
gen male = 1 if wages > bestfit
replace male = 0 if wages < bestfit


*****************************************
*1b. Generate plots
*****************************************

* below, I'm installing user-written stata packages to make graphs look pretty. 
* stata is a really powerful tool and you can do a lot of things with it. If you want to do something interesting, like produce a cool plot, and if stata's basic setup doesn't have this feature, 99% of the time, someone would have written a package for it.
* the way to download a package is to type ssc install <name of package>. The ", replace" is telling stata to replace this package if it already exists on your system.
*net install <package code name> is another way to do the same thing as above. This is sometimes necessary, and the technical details are irrelevant for you now. If you need to do net install instead of ssc install, you will be told this wherever you find the information from on Google.
* color_style has a bunch of cool colours that I personally like, so I just downloaded it.
* to see what colours it has, type "help color_style" (without the speech marks) on your stata main window
* also check out this link: https://github.com/friosavila/playingwithstata/blob/gh-pages/articles/palette.md
* the other packages are stuff that color_style requires before it can run. 
ssc install color_style, replace
net install gr0075.pkg, replace
ssc install grstyle, replace 

*set color_style to a scheme called "egypt" (see link above)
color_style egypt

*notes on how I made this graph is in the overview.do file in ps9
twoway (scatter wages hours if Educ == 1, mcolor(%40)) ///
(scatter wages hours if Educ == 0, mcolor(%40)) ///
(lfit wages hours, lwidth(medthick) lcolor(black) lpattern(dash)), ///
yscale(range(0 400) extend) ylabel(#5) name(onlyhours, replace) ///
legend(order(1 2) label(1 "High education") label(2 "Low education")) ///
ytitle("Wage (in $)") ///
title("Which model has the highest R{superscript:2}? Lowest?" " " "wages{subscript:i} = {&alpha} + {&beta}{subscript:1}*Hours{subscript:i} + {&epsilon}{subscript:i}", size(medium))

twoway (scatter wages hours if Educ == 1, mcolor(%40)) ///
(scatter wages hours if Educ == 0, mcolor(%40)) ///
(lfit wages hours if Educ == 1, lwidth(medthick) lcolor(black) lpattern(dash)) ///
(lfit wages hours if Educ == 0, lwidth(medthick) lcolor(black) lpattern(dash)), ///
yscale(range(0 400) extend) ylabel(#5) name(educ, replace) ///
legend(order(1 2) label(1 "High education") label(2 "Low education")) ///
ytitle("Wage (in $)") ///
title("Which model has the highest R{superscript:2}? Lowest?" " " "wages{subscript:i} = {&alpha} + {&beta}{subscript:1}*Hours{subscript:i} + {&beta}{subscript:2}*Educ{subscript:i} + {&epsilon}{subscript:i}", size(medium))

twoway (scatter wages hours if Educ == 1 & wages > bestfit, mcolor(%40)) ///
(scatter wages hours if Educ == 1 & wages<bestfit, mcolor(%40)) ///
(scatter wages hours if Educ == 0 & wages > bestfit, mcolor(%40)) ///
(scatter wages hours if Educ == 0 & wages < bestfit, mcolor(%40)) ///
(lfit wages hours if Educ == 1 & wages > bestfit, lwidth(medthick) lcolor(black) lpattern(dash)) ///
(lfit wages hours if Educ == 1 & wages < bestfit, lwidth(medthick) lcolor(black) lpattern(dash)) ///
(lfit wages hours if Educ == 0 & wages > bestfit, lwidth(medthick) lcolor(black) lpattern(dash)) ///
(lfit wages hours if Educ == 0 & wages < bestfit, lwidth(medthick) lcolor(black) lpattern(dash)), ///
yscale(range(0 400) extend) ylabel(#5) name(gender_and_educ, replace) ///
legend(order(1 2 3 4) label(1 "High education Males") label(2 "High education Females") ///
label(3 "Low education Males") label(4 "Low education females")) ///
ytitle("Wage (in $)") ///
title("Which model has the highest R{superscript:2}? Lowest?" " " "wages{subscript:i} = {&alpha} + {&beta}{subscript:1}*Hours{subscript:i} + {&beta}{subscript:2}*Educ{subscript:i} + {&beta}{subscript:3}*Gender{subscript:i} + {&epsilon}{subscript:i}", size(medium))


reg wages c.hours
*save the R^2 from the above regression into a "local variable". I've written what "locals" are in overview.do under ps9.
local r2 = round(`e(r2)',0.001)
twoway (scatter wages hours if Educ == 1, mcolor(%40)) ///
(scatter wages hours if Educ == 0, mcolor(%40)) ///
(lfit wages hours, lwidth(medthick) lcolor(black) lpattern(dash)), ///
yscale(range(0 400) extend) ylabel(#5) name(onlyhours_withr2, replace) ///
legend(order(1 2) label(1 "High education") label(2 "Low education")) ///
ytitle("Wage (in $)") ///
title("Which model has the highest R{superscript:2}? Lowest?" " " "wages{subscript:i} = {&alpha} + {&beta}{subscript:1}*Hours{subscript:i} + {&epsilon}{subscript:i}", size(medium)) caption("R{superscript:2} = `r2'") 

reg wages c.hours i.Educ
local r2 = round(`e(r2)',0.001)
twoway (scatter wages hours if Educ == 1, mcolor(%40)) ///
(scatter wages hours if Educ == 0, mcolor(%40)) ///
(lfit wages hours if Educ == 1, lwidth(medthick) lcolor(black) lpattern(dash)) ///
(lfit wages hours if Educ == 0, lwidth(medthick) lcolor(black) lpattern(dash)), ///
yscale(range(0 400) extend) ylabel(#5) name(educ_withr2, replace) ///
legend(order(1 2) label(1 "High education") label(2 "Low education")) ///
ytitle("Wage (in $)") ///
title("Which model has the highest R{superscript:2}? Lowest?" " " "wages{subscript:i} = {&alpha} + {&beta}{subscript:1}*Hours{subscript:i} + {&beta}{subscript:2}*Educ{subscript:i} + {&epsilon}{subscript:i}", size(medium)) caption("R{superscript:2} = `r2'") 

reg wages c.hours i.Educ i.male
local r2 = round(`e(r2)',0.001)
twoway (scatter wages hours if Educ == 1 & wages > bestfit, mcolor(%40)) ///
(scatter wages hours if Educ == 1 & wages<bestfit, mcolor(%40)) ///
(scatter wages hours if Educ == 0 & wages > bestfit, mcolor(%40)) ///
(scatter wages hours if Educ == 0 & wages < bestfit, mcolor(%40)) ///
(lfit wages hours if Educ == 1 & wages > bestfit, lwidth(medthick) lcolor(black) lpattern(dash)) ///
(lfit wages hours if Educ == 1 & wages < bestfit, lwidth(medthick) lcolor(black) lpattern(dash)) ///
(lfit wages hours if Educ == 0 & wages > bestfit, lwidth(medthick) lcolor(black) lpattern(dash)) ///
(lfit wages hours if Educ == 0 & wages < bestfit, lwidth(medthick) lcolor(black) lpattern(dash)), ///
yscale(range(0 400) extend) ylabel(#5) name(gender_and_educ_withr2, replace) ///
legend(order(1 2 3 4) label(1 "High education Males") label(2 "High education Females") ///
label(3 "Low education Males") label(4 "Low education females")) ///
ytitle("Wage (in $)") ///
title("Which model has the highest R{superscript:2}? Lowest?" " " "wages{subscript:i} = {&alpha} + {&beta}{subscript:1}*Hours{subscript:i} + {&beta}{subscript:2}*Educ{subscript:i} + {&beta}{subscript:3}*Gender{subscript:i} + {&epsilon}{subscript:i}", size(medium)) caption("R{superscript:2} = `r2'")

*****************************************
*1c. Notes based on plots.
*****************************************

/*
You'll notice:
R^2 is increasing when you add variables.
But the R^2 increment from 2nd model to 3rd model is very small.
You'll also notice that with the 1st and 2nd models, we get a very fairly good assessment of the relationship between hours and wages, regardless of R^2. 

Do we need to worry about the R^2? There's no black and white answer to this, but a generally, NO, it does not matter. 
For instance, If you're working with microdata (individuals, households, firms, districts etc.) and regressions at these micro levels, then don't worry so much about the R^2. At the micro levels that I mentioned, there are just 1000s of factors that affect a dependent variable. For wages, it could be your ethnicity, age, marriage status, gender, mental health, which region you're from, education, did you enter the job market during a recession, do you have a strong network, does your region have strong political institutions etc. etc. etc. Adding ALL of these factors is the only way R^2 will increase. However, if we add all these factors, then you increase standard errors (I've uploaded pictures on GitHub on what these mean.)

So do we need to add the 3rd variable on gender?
There is no right answer to this. Adding a variable is useful if:
(a) omitting gender biases the results. In the data above removing gender does not bias the coefficient (i.e., we don't get different slopes in the model adding gender vs. not adding gender.)
(b) If you want to break down the effect of hours further by gender, you would do this by having another RHS term for Hours X Gender. Do we need an hours X gender term in the above data? (answer is no. To understand why, see overview in ps9)
(c) If you want to understand the average effect of hours on wages, but you want to
		(i) remove gender effects from hours AND 
		(ii) remove gender effects from wages 
*/


*******************************************************************************
*******************************************************************************
*		2. Actual problem set - how education drives wages
*******************************************************************************
/*
		2a. Code Setup/Housekeeping
		2b. Exploring variables
		2c. Correcting some data errors
		2d. Some dumb regressions (and why they're dumb)
		2e. More sensible regressions (but still won't generate causality) and comments on each
		2f. Final thoughts on modelling and causality

*/
*******************************************************************************

*****************************************
*2a. Code Setup/Housekeeping
*****************************************

*edit this. If you have any questions, please let me know
  cd "..."
  use "...", clear
  log using "...", text replace

*****************************************
*2b. Exploring variables
*****************************************
* Qu 2: cleaning data

  desc
  sum 
/* 
notes:
1. max wage of 999999 -> possible code for missing 
2. variation in number of observations -> missing values
3. dummy/qualitative variables coded 0 1
*/ 

*****************************************
*2c. Correcting some data errors
*****************************************
  sum wage, d
  recode wage 999999=. 
  replace lwage=. if wage==.
  sum educ, d
  recode educ 1800 = . 
  
*****************************************
*2d. Some dumb regressions (and why they're dumb)
*****************************************

* Qu 4: 
* The primary objective in question 2 is to maximise the R-squared: the 
* proportion of variation in the explanatory variable explained by the model. 
* This is a purely mechanical objective. 

* Example 1: you could regress lwage on itself. 

  reg lwage lwage
  
* Not very useful. However, a more general point is, be careful what you 
* regress on what: do not regress Y on a proxy for Y. 

* Example 2: you could add a dummy for every individual in the regression and this 
* would give you an R-squared of 1. 
  
  preserve
  capture drop id
  gen id=_n
  keep if id<100
  xi: reg lwage i.id 
  restore
  
* not very useful (except to compare wages between individuals). 

* Example 3A: Run a regression in levels of all available variables: 

  reg lwage educ exper  
* there are so many problems with the below regression
* hours is one of the x variables. but it's endogenous. "Endogenous" means many things. In this case, it means that wage (the dependent variable) might cause hours. Imagine a CEO who earns a lot of wages. Because they earn a lot from their employer, they might be motivated to work extra hours. So you're not accounting for things like reputation (which is hard to measure), pressure from board of governors (again hard to measure) etc. By not accounting for these important variables AND adding hours, you're violating the assumption of E(error|x) = 0. In our case, this means that E(error|hours) = 0 is not true. That's because I can rewrite error = alpha*pressure from others. On average, for any given value of hours per week (say 60 hours as an example), the pressure that this person faces would be high. On the contrary, the pressure faced by someone who works a few hours out of choice is very small. So E(pressure|hours) not equal to 0.
* tenure is also endogenous under the same arguments as above and violates the E(error|x) = 0 assumption.
* General, age = experience + education years + 4 years. That means we have age appearing twice in this equation!
* the others are good variables to add. But there are so many things we're missing like gender, university that they studied in etc.
  reg lwage educ exper hours IQ tenure age i.married i.black i.south i.urban sibs 

* Example 3B: add squared terms to the regression

  gen sq_hours=hours^2
  gen sq_IQ=IQ^2
  gen sq_educ=educ^2
  gen sq_exper=exper^2
  gen sq_tenure=tenure^2
  gen sq_age=age^2
  gen sq_sibs=sibs^2
  
  *squared terms are useful to add, only if you think the relationship of a variable and wages are non-linear.
  *for example: age^2 is a good term to add. There's a U-shaped relationship between age and log(wage) generally. In your 20s, wages rise very rapidly, but once someone reaches around the mid-30's wages don't rise as rapidly. Moreover, a young manager would earn more than a very old manager in the same position. That's because a very old manager has fewer skills compared to the young person who got promoted to this position. So along the life cycle, wages rise very sharply, then plateau, then starts to fall (accounting for other things such as education, skills etc.). Notice btw that we don't have skills in this equation. so that's a relevant omitted variable.
  *education^2 on the other hand is not a useful variable. Accounting for other factors like skills, age etc., there's no reason to suppose a non-linear relationship between education and wages.
  reg lwage educ exper hours IQ tenure age married black south urban sibs sq_*
  
* Example Model 3C: add interactions to the regression, for example on educ.

  gen i_educ_IQ=educ*IQ
  gen i_educ_hours=educ*hours
  gen i_educ_exper=educ*exper
  gen i_educ_tenure=educ*tenure
  gen i_educ_age=educ*age
  gen i_educ_sibs=educ*sibs
  gen i_educ_married=educ*married
  gen i_educ_black=educ*black
  gen i_educ_south=educ*south
  gen i_educ_urban=educ*urban
  
  reg lwage educ exper hours IQ tenure age married black south urban sibs sq_* i_*

/* 
The above process is meant to make you realise it is very difficult to give an meaning/interpretation to the coefficients in these models. Even though they are not very useful to explain relationships. The model can be useful for prediction. For instance: if I have 5 years of education, live in the south, ... etc, I am likely to then get x wages.
*/

/*
* MAIN POINT: IF YOU INTERESTED IN EXPLAINING UNDERLYING RELATIONSHIPS, CAUSAL RELATIONSHIPS, 
* DO NOT CONSTRUCT REGRESSIONS IN A FASHION SIMILAR TO THE ABOVE.
*/


*****************************************
*2e. More sensible regressions (but still won't generate causality) and comments on each
*****************************************


****************************************
****************************************
* Question 5
****************************************
****************************************

/*
1. In order to get usual interpretations, we need to relate CLRM assumptions to our regression. 2. This is why it is important to constuct a model step by step, thinking about what you are doing. At each stage we want to better identify the effect of X on Y by weakening the zero conditional mean assumption [E(error|x) = 0]. This is what we do next. 
*/
   

* We aim to run the following base regression: 
 
  reg lwage educ exper sq_exper tenure IQ black urban south
  
  
  reg lwage educ  // A one year increase in education is predicted to increase wage by 6% on average. 
  reg lwage educ exper sq_exper  // note the coefficient on education has increased since cov(educ, exper)<0 while cov(wage, exper)>0 
  reg lwage educ exper sq_exper tenure 
  reg lwage educ exper sq_exper tenure IQ  // note the coefficient on education has decreased since cov(educ, IQ)>0 while cov(wage, IQ)>0
  reg lwage educ exper sq_exper tenure IQ black urban south 
  
  reg lwage educ 
  estimates store m1, title(M1)
  reg lwage educ exper sq_exper 
  estimates store m2, title(M2)
  reg lwage educ exper sq_exper tenure 
  estimates store m3, title(M3)
  reg lwage educ exper sq_exper tenure IQ 
  estimates store m4, title(M4)
  reg lwage educ exper sq_exper tenure IQ black urban south 
  estimates store m5, title(M5)

* A useful way to present results: 
  estout m1 m2 m3 m4 m5, cells(b se p) stats(r2 N) 
  * or maybe with p-values and not stars.  
  estout m1 m2 m3 m4 m5, cells(b(fmt(3)) se(par fmt(3)) p(par fmt(3)))  stats(r2 r2_a N, fmt(%9.3f %9.0g) labels(R-squared))

* We have potentially controlled for ("exogenous") variables: exper, tenure, ethnicity, IQ, and region and educ is still strongly correlated with wage. However, many possible alternative explanations: which university they went to, maturity, talent etc. Now, we don't think we have a causal effect, but we have moved closer, potentially.

*****************************************
*2f. Final thoughts on modelling and causality
*****************************************

/*
We have come to the following (unhelpful) conclusions:
1. Having a high R^2 is not necessarily good.
2. Some variables will increase R^2, but are not exogenous (like hours worked in a week), and thus it doesn't make logical sense to account for them. 
3. Adding too many variables will eventually make your model lose meaning (by increasing standard errors - I have added pictures in the folder to show you what this looks like visually). 
4. Most models will never help you achieve causality
5. We didn't discuss this, but if you randomise how many years of education people get, you'll be sent to prison or be labelled as a dictator - both of which are not good for your reputation.

So what do we do next? 

We can't randomize education, but the world is a funny place, and nature/course of history has run experiments for us. We just need to look out for these and find data.

Consider the case of the Indonesian government constructing 61,000 schools between 1973-1978. Someone born just a few years before this time, had much easier access to education (and thus more enrollment), compared to someone born many years before this time. Using data from this, Esther Duflo in a very important paper from 2001, finds that education does in fact, causally increase wages (in Indonesia at least).

*/  
