************************************
* Problem set 13
************************************

* Q1/2/3 - see answer sheet

* Q4. 

  reg lincome cigs educ age agesq
 
* Increasing the number of cigarettes smoked a day by one is predicted to increase income by 0.1%, on average. 
* Note, however, this is very insignificant, i.e. there is no statistical effect. 
  
  reg cigs lincome educ age agesq lcigpric restaurn
  
* Increasing wage by 1% is predicted to increase the number of cigarettes smoked per day by 0.0088, on average.
* Again the coefficient is very insignificant, i.e. there is no statistical effect.  

* 1st mode1: smoking may effect income through days or productivity lost through 
* poor health. 
* 2nd model: the higher ones income the higher the demand for cigs (assuming they
* are a normal good among smokers).

* 5. 

* We may potentially use cigprice and smoking restrictions as IVs. We can test for relevance with an F-test in the first stage: 

  reg cigs educ age agesq  lcigpric restaurn
  test  lcigpric restaurn
  
* They are jointly significant at the 5% level, p-value of 0.0441. Exogeneity of the 
* instruments is dicussed below. 

* 6. 

  ivregress 2sls lincome (cigs=lcigpric restaurn) educ age agesq
  
* Now the coefficient on cigs is negative and almost significant at the 10% level
* against a two-sided alternative.  The estimated effect is very large:  
* each additional cigarette someone smokes lowers predicted income by about 4.2%. 
* The 95% CI for the coefficient on cigs is very wide.

* We can question the exogeneity of our instruments. 
* Assuming that state level cigarette prices and restaurant smoking restrictions are 
* exogenous in the income equation may be problematic. Incomes are known to vary by region,
* as do restaurant smoking restrictions. It could be that in states where income is lower
* (after controlling for education and age), restaurant smoking restrictions are less
* likely to be in place. 

