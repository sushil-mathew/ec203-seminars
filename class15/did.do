********************************************************************************
* Get into groups and help each other
* One person in the group keep track of time: If you take more than 5 minutes for a task, give me a shout
* Most of the commands you'll need to use today are available on the do-file from the previous problem set (also on GitHub)
* If you haven't used a command before I have written it down 
* After 45 minutes past the hour, skip to Task 15 even if you haven't completed the rest (I'll be sending you a do-file)
********************************************************************************

*Task 1: change directory
*Task 2: use data file
*Task 3: create log file

*Task 4: summarize and see if the data make sense? (any abnormal values? missing values? do the averages, standard deviations, min and max values look alright?)

*Task 5: what is the unit of analysis of the dataset? (in other words, does each observation/row correspond to a village, or household, or individual? Use household_identifier, locality_identifier, treat_village and time2018 to answer this). Use this information to give an "English" interpretation of the regression you will use later (when you reach Tasks 12 and 14).
isid locality_identifier
isid household_identifier
isid locality_identifier time2018
isid household_identifier time2018

*Task 6: In 2015, is income per capita the same in the treatment and control groups on average? (hint: use t-tests or regressions) do you think it is/is not a problem?

*Task 7: list down the variables in the dataset that would not be affected by the policy change (or, in other words, list down variables that are exogenous to the experimental intervention)

*Task 8: How similar are the treatment and control groups pre-treatment? (hint: use t-tests and observable characteristics)
*Task 9: How similar are the treatment and control groups post-treatment? (hint: use t-tests and observable characteristics)
*Task 10: Having seen the output so far, looking at the output you've gotten so far, what can you say about the parallel (or common) trends assumption? (Page 10/22 in last week's lecture notes) 

*Task 11: run a diff-in-diff regression of the form:
*y = a + b1*Treated + b2*(Time dummy for year post-treatment) + b3*(Treated)*(Post-treatment dummy) + error
*note the coefficients, standard errors, t values, p values and 95% confidence intervals
*Task 12: interpret the coefficients (hint: slide 14/22 in last week's lecture notes). State your interpretation in English, in terms of the unit of analysis (Task 5)

*Task 13: run the same regression as above, and add the exogenous controls that you think are important. Be careful to avoid multicollinearity (if in doubt, run a regression only between the variables you think are multicollinear, and look at the R^2). 
*Task 14: Compared to the previous diff-in-diff regression, what happens to coefficients, standard errors, t-values, p values and 95% confidence intervals? Why?

*Task 15: run the following commands. Locate where the DiD estimate is on the graph. Compare it to your regression results. Go to your lecture notes, page 15/22, and compare your graph with the figure from your lecture notes
reg income i.treat_village##i.time2018 
margins i.treat_village#i.time2018
predict untreated if treat_village == 0
replace untreated = untreated + _b[1.treat_village]
marginsplot, xdimension(time2018) addplot(line untreated time2018)


*Task 16: close log file
