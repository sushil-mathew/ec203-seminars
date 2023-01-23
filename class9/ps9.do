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

  cd "C:\Users\u1972955\OneDrive - University of Warwick\EC203\Term 2\class9"  // add your working directory in here
  use wage2, clear
  log using ps9, text replace

  gen wage=exp(lwage)
  
  ttest lwage, by(male)
  ttest wage, by(male)
  
  reg wage male
  
  reg lwage male 
  reg lwage male school
  predict lw_hat
  twoway scatter lw_hat school
  twoway scatter lw_hat school if male==1 || scatter lw_hat school if male==0
  
  gen exper2=exper^2
  reg lwage school exper exper2 male
  predict lw_hat2
  twoway scatter lw_hat2 exper if male==1 || scatter lw_hat2 exper if male==0

  ta region
  ta region, nol
  
  gen N=1 if (region==5 | region==6 | region==7)
  replace N=0 if (region==0 | region==1 | region==2 | region==3 | region==4)

* or
  gen byte north=(region==5 | region==6 | region==7)
  ta north

  gen male_nrth=male*north
  
  reg lwage school exper exper2 male north male_nrth
  test male_nrth
  
* structural break: male versus female  
  
  foreach i in school exper exper2 {
  gen male_`i'=`i'*male
  }
  
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
