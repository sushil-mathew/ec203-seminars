clear all

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

reg wages hours i.Educ 
predict bestfit

color_style egypt
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

gen male = 1 if wages > bestfit
replace male = 0 if wages < bestfit

reg wages c.hours
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

* EC203: Problem set 11

  cd "..."
  use "..."
  log using "...", text replace
  
* Qu 2: cleaning data

  desc
  sum 
/* 
notes:
1. max wage of 999999 -> possible code for missing 
2. variation in number of observations -> missing values
3. dummy/qualitative variables coded 0 1
*/ 

  sum wage, d
  recode wage 999999=. 
  replace lwage=. if wage==.
  sum educ, d
  recode educ 1800 = . 
  

* Qu 3: 
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

* Example 3A: Run a regression in levels: 

  reg lwage educ exper  
  reg lwage educ exper hours IQ tenure age married black south urban sibs 

* Example 3B: add squared terms to the regression

  gen sq_hours=hours^2
  gen sq_IQ=IQ^2
  gen sq_educ=educ^2
  gen sq_exper=exper^2
  gen sq_tenure=tenure^2
  gen sq_age=age^2
  gen sq_sibs=sibs^2
  
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

******************************
* MAIN POINT: IF YOU INTERESTED IN EXPLAINING UNDERLYING RELATIONSHIPS, CAUSAL RELATIONSHIPS, 
* DO NOT CONSTRUCT REGRESSIONS IN A FASHION SIMILAR TO THE ABOVE.
******************************

****************************************
****************************************
* Question 4
****************************************
****************************************

/*
1. In order to get usual interpretations, we need to relate CLRM assumptions to our regression. 2. This is why it is important to constuct a model step by step, thinking about what you are doing. At each stage we want to better identify the effect of X on Y by weakening the zero conditional mean assumption. This is what we do next. 
*/
   
* In the above model the number of observations in the regression between wage and education is 900. We need to keep the number of observations the same across models. 

* We aim to run the following base regression: 
 
  reg lwage educ exper sq_exper tenure IQ black urban south
  
  gen base_s=1 if (lwage!=. & educ!=. & exper!=. & sq_exper!=. & ///
  tenure!=. & black!=. & IQ!=. & urban!=. & south!=.)
  
  reg lwage educ if base_s==1 // A one year increase in education is predicted to increase wage by 6% on average. 
  reg lwage educ exper sq_exper if base_s==1 // note the coefficient on education has increased since cov(educ, exper)<0 while cov(wage, exper)>0 
  reg lwage educ exper sq_exper tenure if base_s==1
  reg lwage educ exper sq_exper tenure IQ if base_s==1 // note the coefficient on education has decreased since cov(educ, IQ)>0 while cov(wage, IQ)>0
  reg lwage educ exper sq_exper tenure IQ black urban south if base_s==1
  
  reg lwage educ if base_s==1
  estimates store m1, title(M1)
  reg lwage educ exper sq_exper if base_s==1
  estimates store m2, title(M2)
  reg lwage educ exper sq_exper tenure if base_s==1
  estimates store m3, title(M3)
  reg lwage educ exper sq_exper tenure IQ if base_s==1
  estimates store m4, title(M4)
  reg lwage educ exper sq_exper tenure IQ black urban south if base_s==1
  estimates store m5, title(M5)

* A useful way to present results: 
  estout m1 m2 m3 m4 m5, cells(b se p) stats(r2 N) 
  * or maybe with p-values and not stars.  
  estout m1 m2 m3 m4 m5, cells(b(fmt(3)) se(par fmt(3)) p(par fmt(3)))  stats(r2 r2_a N, fmt(%9.3f %9.0g) labels(R-squared))

* We have potentially controlled for ("exogenous") variables: exper, tenure, ethnicity, IQ, and region and educ is still strongly correlated with wage. However, many possible alternative explanations: unoberservable individual characteristics, household input, school inputs, sheep-skin effects, ... etc. Now, we don't think we have a causal effect, but we have moved closer, potentially.

*********************************
* Qu 5
*********************************

* Discuss methods that have been used in the literature IV, RDD, DID. Note panel data here is often not that useful as education doesn't vary much over time (once people enter the labour market). These are the methods we discuss next  
  
