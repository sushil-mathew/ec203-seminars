*if you click "DO" or "Execute(DO)" on the top of this screen, your file should run without errors. 
*if it does have errors, try to read the error on the screen, maybe google this error, and try to fix it yourself.
*if you spend 10 mins and it still doesn't work, email me on sushil.mathew.1@warwick.ac.uk
*if you have any other questions about the do-file or your material: also email me or let's meet during office hours.

  cd "C:\Users\u1972955\Dropbox\TA\EC203\Term 2\ec203-seminars\class10"
  use crime2, clear
  des
  capture log using ps10, replace text

  *this runs the regression narr86 = alpha + beta1*ptime86 + beta2*qemp86 + ..... + error
  *you'll get a bunch of output, and not all of them are necessary. The only things you need to focus on are the "Coefficient" and P > |t| columns. 
  *For a continuous x variable, increasing x by 1 unit (replace x with the variable name and "unit" with the actual unit of measurement of x), would increase(if coefficient is positive) or decrease (if coefficient is negative) y (replace with actual y variable) by <coefficient> (replace with actual coefficient) units (replace with actual unit of measurement of y), on average, holding all else constant. For a dummy x variable, the coefficient gives the average difference in y for group x=1 (for ex: hispanic people) compared to group x=0 (non-hispanic people), on average, holding all else constant.
  reg narr86 ptime86 qemp86 pcnv avgsen black hispan

  *drop arr is telling stata to drop a variable called "arr" if it exists. If it doesn't exist Stata throws up an error saying this.
  *So you add "capture" to tell stata to ignore the error and run past it.
  capture drop arr
  *the below steps are self-explanatory. To understand what it is doing. Go to the stata main window. Type "browse" - your data window should pop up now. Then come back to this do-file and run the next 3 lines one by one. Each time you run a command, go to the data window and try to spot what has changed.
  gen arr=.
  replace arr=1 if narr86>0
  replace arr=0 if narr86==0
  
  *I have given notes on what the below command means in the previous week's do file: ps9.do.
  ta arr
  
 *the below code block, does the exact same thing as above, but in a different way. The above version is easier to read and understand, the below version is slightly mind-bendy, but has the advantage of being short. See what works for you. Regardless of what you do, it's always good practice to comment on what you're doing as you go along. Just like how I'm commenting. It is very likely that you yourself don't understand what you've done (it happens to me a lot). So comments are helpful.
*The below code is telling stata, if narr86>0 is true (True in computer language has the number "1" attached to it), then generate arr_v2 (v2 stands for version 2), to take the value 1. If narr86>0 is false (false = 0 in computer language), then assign 0 to arr_v2.
 * * * * * * Aside * * * * * * * * 
 gen arr_v2 = narr86>0
 tab arr_v2
* * * * * * * * * * * * * * * * * 

*here be very careful, and note that the y variable is a dummy. For a continuous x variable, increasing x by 1 unit (replace x with the variable name and "unit" with the actual unit of measurement of x), would increase(if coefficient is positive) or decrease (if coefficient is negative) the probability that y = 1, on average, holding all else constant. For a dummy x variable, the coefficient gives the probability that y=1, if x=1, on average, holding all else constant.
  reg arr ptime86 qemp86 pcnv avgsen black hispan
  
  reg arr ptime86 qemp86 pcnv avgsen black hispan
  capture drop yhat
  predict yhat  // generate the predicted values: for a single linear regression, the predicted values are basically the line that you draw through the data points.
				//yhat contains everything in the regression equation except the error term. So the true data minus predicted values, gives you the error term.
  sum yhat, d //d stands for "detail"
  count if (yhat<0 | yhat>1)
  
  reg arr ptime86 qemp86 pcnv avgsen black hispan
  capture drop resid   // generate the residuals
  predict resid, resid //the resid option helps you find the residuals
  histogram resid

  reg arr ptime86 qemp86 pcnv avgsen black hispan
  *the below command tests for heteroskedasticity (whether the error variance is constant) in a model where you have all the listed "x" variables on the right hand side. F(k, n-k-1) is the test statistic, F is the critical value. If Probability of getting a test statistic > critical value with this data is approximately = 0 then we can reject the null of constant variance. To understand what an F test does in plain English, see my comments on ps9.do (the previous problem set). You should also see the below section that says "running the above test manually" 
  estat hettest ptime86 qemp86 pcnv avgsen black hispan, fstat

* running the above test manually:
	*the above estat hettest does many calculation in one go. The below block of code starting with reg, and ending with the test command does the exact same as estat hettest.

  reg arr ptime86 qemp86 pcnv avgsen black hispan
  capture drop resid
  predict resid, residuals  // generate the residuals
  capture drop resid2
  gen resid2=resid^2  // square the residuals
  reg resid2 ptime86 qemp86 pcnv avgsen black hispan
  test ptime86 qemp86 pcnv avgsen black hispan

  *the robust option tells stata to expect heteroskedasticity and to account for it
  reg arr ptime86 qemp86 pcnv avgsen black hispan   // non-robust s.e.s
  reg arr ptime86 qemp86 pcnv avgsen black hispan, robust  // robust s.e.s

  *find these numbers on the regression results table, then find the formula sheet on Moodle>EC203>Revision Material>Formula Sheet.pdf
  *then look for "Tests for regression slope coefficient", and connect these numbers to the stata output and the formula.
  *This command produces the output: -8.4172549. See if you can find a number that is approximately equal to this value in the regression table
  display -0.0240885/0.0028618

  
  log close
