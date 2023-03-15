  cd "C:\Users\u1972955\OneDrive - University of Warwick\EC203\Term 2\class16"

  use "sleep", clear
    
  cap log using class16, replace text
  
 pause on
 
  gen hrssleep = slpnap/60
  gen hrswork = totwrk/60

  reg hrssleep d81 hrswork educ gdhlth marr yngkid

  reg hrssleep d81 hrswork educ gdhlth marr yngkid, cluster(id)
* Q: What's the difference between above 2 regression tables and why?   
pause
* too many issues with this, E (ai|Xit) != 0; cov(ei, ej) != 0; cov(uit, uis) != 0
* this is called POLS (pooled OLS)

  xtset id year
  xtreg hrssleep d81 hrswork educ gdhlth marr yngkid, re
* xtreg stands for x (cross section) t (time) regress
* re stands for random effects
* the transformation and details are beyond scope, but brief intro on page 40-41/52
* assume E(vit|Xit) = 0
* strong assumption
pause 

  sort id year
  by id: gen d_d81=d81[2]-d81[1] if _n==2
  by id: gen d_hrssleep=hrssleep[2]-hrssleep[1] if _n==2
  by id: gen d_hrswork=hrswork[2]-hrswork[1] if _n==2
  by id: gen d_educ=educ[2]-educ[1] if _n==2
  by id: gen d_gdhlth=gdhlth[2]-gdhlth[1] if _n==2
  by id: gen d_marr=marr[2]-marr[1] if _n==2
  by id: gen d_yngkid=yngkid[2]-yngkid[1] if _n==2

  reg d_hrssleep d_hrswork d_educ d_gdhlth d_marr d_yngkid
 *this is a first difference estimator, fd is a similar transformation to fe to remove ai (derivation in pages 25-28/52 of lecture slides)
  pause
  
 *both fe and fd don't require E(ai|Xit) = 0, which is why a lot of people prefer to use these - but as we saw, it wipes out between individual variation
 pause
  
  xtreg hrssleep d81 hrswork educ gdhlth marr yngkid, fe 
* fe stands for fixed effects aka within estimator 
* ai correlated with covariates, so fe is a transform to remove ai (derivation in pages 19-21/52 of lecture slides)
pause 
* fe regressions tell you how x varies across time on average. but tells you nothing about how it varies between people (because we're controlling for it). it wipes out between individual variation when you control for them 
pause
* Q: what's the difference between estimates in fe and fd model?
pause
* A: If T=2, FD and FE are the same transformation, mathematically
 
  * second way to do fixed effects, (manually transforming the data) (page)
  sort id year
  by id: gen DE_81=d81-(d81[2]+d81[1])/2 
  by id: gen DE_hrssleep=hrssleep-(hrssleep[2]+hrssleep[1])/2
  by id: gen DE_hrswork=hrswork-(hrswork[2]+hrswork[1])/2
  by id: gen DE_educ=educ-(educ[2]+educ[1])/2
  by id: gen DE_gdhlth=gdhlth-(gdhlth[2]+gdhlth[1])/2
  by id: gen DE_marr=marr-(marr[2]+marr[1])/2
  by id: gen DE_yngkid=yngkid-(yngkid[2]+yngkid[1])/2
    
  reg DE_hrssleep DE_81 DE_hrswork DE_educ DE_gdhlth DE_marr DE_yngkid
	
* third way to do fixed effects, (adding dummies for each person)
  xi: reg hrssleep d81 hrswork educ gdhlth marr yngkid i.id 

  
  xtreg hrssleep d81 hrswork educ gdhlth marr yngkid, fe
  estimates store fe
  xtreg hrssleep d81 hrswork educ gdhlth marr yngkid, re
  estimates store re
  hausman fe re
  
  xtset id year
  reg hrssleep d81 hrswork educ gdhlth marr yngkid
  outreg2 using reg_ex, replace ctitle(POLS) word
  reg hrssleep d81 hrswork educ gdhlth marr yngkid, cluster(id)
  outreg2 using reg_ex, append ctitle(POLS cluster) word
  xtreg hrssleep d81 hrswork educ gdhlth marr yngkid, re
  outreg2 using reg_ex, append ctitle(RE) word
  xtreg hrssleep d81 hrswork educ gdhlth marr yngkid, fe
  outreg2 using reg_ex, append ctitle(FE) word
  
  log close
  exit

 

