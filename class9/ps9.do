*This problem set answers the following research questions about wages in the UK:

*Q2 and Q3: what's the average gender wage gap?
*Q2 and Q3: Is this difference meaningful?
*Q4: Accounting for gender, how does education predict wages?
*Q4: Accounting for education, what's the gender wage gap on average?
*Q5: Accounting for education and experience, is there a gender wage gap?
*Q5: Accounting for education and experience, is there a wage difference between north and south in the UK?
*Q5: Accounting for education and experience, is there a gender wage gap between north and south?
*Q6: Does it make sense to do 2 separate analyses for males and females? Do males and females differ in wages across so many different dimensions? (Hint: go through notes on Chow test)
*Q7: Accounting for education and experience, what's the average wage in different regions compared to London? 

  clear all
  set more off
	
  *cd stands for "change directory". Navigate to the folder where you've downloaded your material. 
  *to do this on your laptop:
  *On Windows, right click after you've navigated to your folder location, click Properties, then select everything that comes after "Location" on the popup. Right click on the highlighted bit. Then click copy.
  *On Mac, navigate and go to the folder where you've downloaded your material. Right click. Click no "Get Info". You'll see a bit that says "Where: Macintosh HD > ...". Starting from the MacIntosh HD bit, select everything that comes after. Right click on the highlighted bit, copy. Come to your do-file, and paste it here.
  *if this doesn't work, please email me.
  cd "C:\Users\u1972955\OneDrive - University of Warwick\EC203\Term 2\class9"  // add your working directory in here
  *the below command calls for a file that's named "wage2.dta" that is stored in the above folder that you just copy-pasted the path to.
  use wage2, clear
  *the line below stores all the output (except graphs) from Stata in a textfile called "ps9.txt" in your folder above. You don't need to run Stata again and again, unless you change something in your code.
  log using ps9, text replace

  *currently wage is present in our dataset as lwage. It's actually ln(wage), or the natural log of wage. We're generating below, the actual value of wage.
  *exp is the exponential function(e). So this is doing e^[ln(wage)]. e and ln cancel each other out, and you're left with wage.
  gen wage=exp(lwage)
  
  *stata gives you a lot of output. All of which are not necessary all the time.
  *the ttest command below is saying, conduct a t-test, where the H0 is lwage(male) = lwage(female). Or in other words, is there a significant wage gap between men and women?
  *In the output given, mean(0) means mean of wage, when male takes the value 0 - in this dataset, this means it's for females.
  * Look carefully at the t-statistic for both the t-tests below and note these values. (It'll be written as "t = <some value>") You're going to see it later again in the regressions, later on in this do-file
  * Ha means alternate hypothesis. There are 3 different ones to choose from. Choose the one that you think is relevant for the question in the problem set.
  * T stands for critical value.
  * See here for an intuitive explanation of critical values, test statistics, p-values and hypothesis tests (copy and paste this link into your browser): https://www.geo.fu-berlin.de/en/v/soga/Basics-of-statistics/Hypothesis-Tests/Introduction-to-Hypothesis-Testing/Critical-Value-and-the-p-Value-Approach/index.html
  ttest lwage, by(male)
  ttest wage, by(male)
  
  *wage is the y variable, male is the x variable. Look out for the t-statistic (some people call this the "t-ratio") in the regression output
  reg wage male
  
  reg lwage male 
  
  *wage is the y variable, male and school are the x variables. Look out for the t-statistic in the regression output
  reg lwage male school
  
  *the predict command gives you all the points on the line that fits the data. Basically, it gives you beta_1*male + beta_2*school, but without the residuals.
  predict lw_hat
  twoway scatter lw_hat school
  twoway scatter lw_hat school if male==1 || scatter lw_hat school if male==0
  
  *experience squared. the relationship between experience and wage is u-shaped (this is a fact derived from decades of labour economics research).
  *this is why we want to control for this U-shape due to experience, so we add experience and experience^2 in the regression.
  gen exper2=exper^2
  reg lwage school exper exper2 male
  predict lw_hat2
  *if you run the below command, you'll see that the predicted value is not a line. It's u-shaped.
  twoway scatter lw_hat2 exper if male==1 || scatter lw_hat2 exper if male==0

  /* ta stands for "tabulate". the ", nol" is short-form for nolabel. In the first command, you'll see which re
  In the output for the first command, you'll see a table with London, south-west, west midlands etc. 
  In the output for the second command, you'll see the exact same table but the "London" will be replaced with the actual numerical values holding these categories.
  This is a special feature of stata. You can define numerical variables, and these numerical variables, could potentially hold some "string" (terminology) or non-numerical characteristics. For an example on how to do this, see the overview.do do-file in the GitHub folder that you downloaded.
  */
  ta region
  ta region, nol
  
  *generate a new variable North (denoted by N), if the regions are in the north, and 0 otherwise.
  * the pipe operator "|" means "OR" so this is saying generate North = 1 if region is 5 or region is 6 or region is 7.
  gen N=1 if (region==5 | region==6 | region==7)
  replace N=0 if (region==0 | region==1 | region==2 | region==3 | region==4)

* another way to do the same thing as above
  gen byte north=(region==5 | region==6 | region==7)
  ta north

  *think about this command carefully. male takes 2 values, 0 (for females) and 1 (for males). north takes 2 values 0 for south, and 1 for north.
  *therefore, in the below generate (or gen in short) command, you get 0 if someone is either female, and/or from the south. You get 1 ONLY in the case where someone is a male AND from the north.
  gen male_nrth=male*north
  
  *here we use the male_nrth variable which takes the value 1 only if someone is a northern male.
  *that means 0 could be female south, female north, or male south.
  *clearly then it becomes difficult to separate out the nuances between 4 different combinations between female-male and north-south.
  *but this is why we have 2 more variables for male and north. 
  *so the coefficient on male_nrth = 1 captures male-north
  *How do we find out the rest?
	*the constant or the intercept captures female-south
	*therefore coefficients on female-south (the intercept denotes as _cons on Stata output) + (male = 1) + (north = 0), gives the effect for male-south
	*coefficients on female-south + (male = 0) + (north=1) gives the effect for female-north 
  reg lwage school exper exper2 male north male_nrth
  test male_nrth
  
* there's a lot going on in the below blocks.
/* foreach i in school exper exper2 does the following
1. Stata assigns a local variable i (a temporary variable) to take the value "school"
2. Stata goes inside the { }
3. it generates a variable male_school = school*male (that means it creates a separate schooling variable for males and another one for females)
4. Stata gets out of { } and returns to foreach i in school exper exper2
5. It has finished school, so it moves on to exper.
6. Stata goes inside { } again.
7. It generates male_exper = exper*male (separate variable for males and females)
8. It does the same thing for exper2.

This is called a loop. Loops are a very useful coding tool. Without a loop you would manually have to type male_school = school*male, and repeat this again for exper and exper2. That would be 3 lines. With a loop you've cut this down to 2 lines. Obviously, that's not a big improvement. But as you go along on this course (and in life if you continue to code), you'll find yourself having to cut down 10 lines to 2 lines or 10,000 lines to 10 lines. Loops are a life-saver. So practice using them when you come across a repetitive task.
*/  
  foreach i in school exper exper2 {
  gen male_`i'=`i'*male
  }
  
  *RSS stands for residual sum of squares. It's one way to measure the variation of the residual terms. 
  *Jargon alert: The first regression is an "unrestricted" model compared to the next regression model that comes after this. 
  *Jargon explanation: In the second model, you're constraining lwage in some way by saying that lwage has to depend on 7 terms. This is opposed to the first model, where it depends only on 4 terms.
  /*When doing data analysis, you face a tradeoff between having a simple model, where you say a simple story, with as few variables as possible. But at the same time not leave out real facts about the world.
	*For ex: think about a simple regression ice_cream_sales = constant + temperature + error. This is intuitive and this unrestricted model would be enough you think. 
	*But actually, the seasons might matter too. relatively hot days in summer will have very different ice cream sales, compared to relatively hot days in the winter. So we might want to add a restriction there.
	*So a more restricted model would have ice cream sales = constant+temperature*season + season + error.
	*But you could restrict ice-cream sales now, by rich and poor. In my mind, adding one more variable for whether someone is going to be rich or poor is quite meaningless. Rich and poor ice cream sales are not going to be dramatically different enough to warrant including this term (or an additional "restriction") in the model. That is, it makes more sense to say that ice cream sales depends on 2 terms (temp*season + season), rather than 3 terms (temp*season + season + rich)
	
	The RSS can be a useful metric to test whether the "restrictions" you're adding is/are useful or not.
	*If the restriction is meaningful, then the RSS (or the variation of the residual term) will decrease drastically, compared to the RSS of the unrestricted model.
	*An F-test does exactly this. It gives an answer to whether the variance of one "object" (in this example, an unrestricted model), is meaningfully different from the variance of another "object" (a restricted model, in this example). This kind of F-Test where you compare a restricted/unrestricted model is called a Chow test, or a test for structural breaks. That is, it asks whether there is something fundamentally (or to use jargon: "structurally") different between the unrestricted and restricted models
	*Note that the Chow test is the last step of the process of building a model. The first step is to reason if your model, if it even makes sense. In the ice cream example above, I didn't need to run a Chow test, to know whether I need to add a rich/poor dummy. If your model fails a logic test (which often requires a lot of thought, and reasoning), then it doesn't matter whether it passes the Chow test or not. This is generally true for any hypothesis test.
*/
  reg lwage school exper exper2 male //  RSS=480.73
  
  reg lwage school exper exper2 male male_school male_exper male_exper2 // RSS=465.89
  test male_school male_exper male_exper2 
  
  display ((480.73-465.89)/3)/(465.89/(2294))
  
  ta region, gen(region_)  // quick way to generate regional dummies

  reg lwage school exper exper2 region_2 region_3 region_4 region_5 ///
  region_6 region_7 region_8 if male==1 // 0.3340
  test region_2 region_3 region_4 region_5 region_6 region_7 region_8
  
  reg lwage school exper exper2 if male==1 // 0.2972

  display ((0.3340-0.2972)/7)/((1-0.2972)/(1363))
    
  log close
