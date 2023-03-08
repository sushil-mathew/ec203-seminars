*change directory
cd "C:\Users\u1972955\OneDrive - University of Warwick\EC203\Term 2\class15"
*use data file
use micro_did_ps, clear
*create log file
log using "ps15", replace text

*summarize and see if the data make sense? (any abnormal values? missing values? do the averages, standard deviations, min and max values look alright?)
summarize, detail
bys treat_village: summarize, detail
bys time2018: summarize, detail

*what is the unit of analysis of the dataset? (in other words, does each observation/row correspond to a village, or household, or individual? Use household_identifier, locality_identifier, treat_village and time2018 to answer this). Use this information to give an "English" interpretation of the regression you will use later (when you reach Tasks 12 and 14).
isid household_identifier time2018 //type "help isid" on the main stata window if it's not clear what this is doing

*In 2015, is income per capita the same in the treatment and control groups on average? (hint: use t-tests or regressions) do you think it is/is not a problem?
ttest income, by(treat_village)

*list down the variables in the dataset, that would not be affected by the policy change (or, in other words, list down variables that are exogenous to the experimental intervention)
//gender of household head, age of household head, age of spouse of household head, education (of adults), 
//a little more unclear: hhsize, dirtfloor, bathroom, land

*How similar are the treatment and control groups pre-treatment? (hint: use t-tests and observable characteristics)
foreach v of varlist age_hh female_hh educ_hh educ_sp hhsize dirtfloor bathroom land {
	display "`v'"
	ttest `v' if time2018 == 0, by(treat_village)
}

*How similar are the treatment and control groups post-treatment? (hint: use t-tests and observable characteristics)
foreach v of varlist age_hh female_hh educ_hh educ_sp hhsize dirtfloor bathroom land {
	display "`v'"
	ttest `v' if time2018 == 1, by(treat_village)
}

*Having seen the output so far, looking at the output you've gotten so far, what can you say about the parallel (or common) trends assumption? (Page 10/22 in last week's lecture notes) 

*run a diff-in-diff regression of the form:
*y = a + b1*Treated + b2*(Time dummy for year post-treatment) + b3*(Treated)*(Post-treatment dummy) + error
reg income i.treat_village##i.time2018  //to understand what this command means type "help fvvarlist" on your main stata window

*note the coefficients, standard errors, t values, p values and 95% confidence intervals
*interpret the coefficients (hint: slide 14/22 in last week's lecture notes). State your interpretation in English, in terms of the unit of analysis (Task 5)


*run the same regression as above, and add the exogenous controls that you think are important. Be careful to avoid multicollinearity (if in doubt, run a regression between the variables you think are multicollinear, and look at the R^2). 
*also be careful to avoid adding things that are affected by policy change (for ex: people may buy more land if they have more savings, so adding a land and treatment variable on the right hand side is like trying to account for the policy twice)
*Compared to the previous regression, what happens to coefficients, standard errors, t-values, p values and 95% confidence intervals?
reg income i.treat_village##i.time2018 age_hh educ_hh hhsize //this is just the regression that I would run, but go with the variables that you think are important and exogenous

*run the following commands. Locate where the DiD estimate is on the graph. Compare it to your regression results. Go to your lecture notes, page 15/22, and compare your graph with the figure from your lecture notes
reg income i.treat_village##i.time2018 
margins i.treat_village#i.time2018
predict untreated if treat_village == 0
replace untreated = untreated + _b[1.treat_village]
marginsplot, xdimension(time2018) addplot(line untreated time2018)


*close log file
log close