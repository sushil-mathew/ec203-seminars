
*change directory
cd "$dropbox/TA/EC203/Term 2/class14"
*use data file
use studentscores, clear
* open log file 
cap log using ps14, replace text 

*ignore the below line (and whenever you see "pause"). This is for me 
pause on


  summarize male frlunch black white hispanic asian 
  *can you interpret the averages?
pause 
  *Try this yourself: On average, what is the difference in scores for those who got tuition vs those who didn't get tuition?
pause
  summarize score_endyr if treat==1, d
  summarize score_endyr if treat==0, d
  ttest score_endyr, by(treat)
  *is this difference, the causal effect of tuition? Why? Why not?
pause 

* graphical analysis: best place to start with rd designs
  twoway (scatter score_endyr score_startyr if score_startyr < 215, mcolor(%50)) ///
  (scatter score_endyr score_startyr if score_startyr >= 215, mcolor(%50)) ///
  , xline(215) legend(off)
  
  *using only information on screen, what quantity on the screen gives us the causal effect?
pause
  
  reg score_endyr score_startyr treat
  *verify
  qui pause 
  
  predict yhat 
  twoway (scatter score_endyr score_startyr, mcolor(%20))(scatter yhat score_startyr, msize(medium)), legend(off)
  *verify again
  *is this the causal effect for everyone (high scorers and low scorers)?
  *where's alpha, coefficient on start year on the graph?
pause
  
  *quasi-randomisation explanation: we don't want systematic differences between treatment and control
pause 
* balancing tests to check "quasi-randomisation"

  ttest age, by(treat)
  *is there a significant difference in age for those in treatment vs control?
  pause
  ttest age if (score_startyr>=213 & score_startyr<=217), by(treat)
  *is there a significant difference in age for those in treatment vs control?
  pause
  ttest male, by(treat)
  *is there a significant difference in share of males in treatment vs control?
  pause
  ttest male if (score_startyr>=213 & score_startyr<=217), by(treat)
   *is there a significant difference in share of males in treatment vs control?
  pause

  ttest frlunch, by(treat)
  pause
  ttest frlunch if (score_startyr>=213 & score_startyr<=217), by(treat)
  pause
  
  ttest white, by(treat)
  pause
  ttest white if (score_startyr>=213 & score_startyr<=217), by(treat)
  pause
  
* explain lowess
  
  twoway scatter score_endyr score_startyr if score_startyr<215, xline(215) ///
  msymbol(Oh) msize(vsmall) || scatter score_endyr score_startyr ///
  if score_startyr>=215, xline(215) msymbol(O) msize(vsmall) ///
  || lowess score_endyr score_startyr if score_startyr<215 ///
  || lowess score_endyr score_startyr if score_startyr>=215 
 pause 
* explain lowess
*what is the below plot telling you?
  twoway scatter score_endyr score_startyr if score_startyr<210, xline(210) ///
  msymbol(Oh) msize(vsmall) || scatter score_endyr score_startyr ///
  if score_startyr>=210, xline(210) msymbol(O) msize(vsmall) ///
  || lowess score_endyr score_startyr if score_startyr<210 ///
  || lowess score_endyr score_startyr if score_startyr>=210, legend(off) 
pause 
*this is called a placebo analysis or a robustness check. We are checking that our results are robust. That is, it shouldn't change if we move to an arbitrary cut-off.
pause
* placebo analysis 2: 220 cut-off

  twoway scatter score_endyr score_startyr if score_startyr<220, xline(220) ///
  msymbol(Oh) msize(vsmall) || scatter score_endyr score_startyr ///
  if score_startyr>=220, xline(220) msymbol(O) msize(vsmall) ///
  || lowess score_endyr score_startyr if score_startyr<220 ///
  || lowess score_endyr score_startyr if score_startyr>=220 
pause 

*let's try polynomial fits  
  reg score_endyr treat score_startyr score_startyr2 score_startyr3
  predict yhat2 
  twoway scatter score_endyr score_startyr if score_startyr<215, xline(215) ///
  msymbol(Oh) msize(vsmall) || scatter score_endyr score_startyr ///
  if score_startyr>=215, xline(215) msymbol(O) msize(vsmall) ///
  || lowess score_endyr score_startyr if score_startyr<215 ///
  || lowess score_endyr score_startyr if score_startyr>=215 ///
  || scatter yhat2 score_startyr, msize(medium) legend(off)
pause 

* fully interactive model
  reg score_endyr treat score_startyr_215 score_startyr2_215 score_startyr3_215 ///
  score_startyr_215_T score_startyr2_215_T score_startyr3_215_T
  predict yhat3 
  twoway scatter score_endyr score_startyr if score_startyr<215, xline(215) ///
  msymbol(Oh) msize(vsmall) || scatter score_endyr score_startyr ///
  if score_startyr>=215, xline(215) msymbol(O) msize(vsmall) ///
  || lowess score_endyr score_startyr if score_startyr<215 ///
  || lowess score_endyr score_startyr if score_startyr>=215 ///
  || scatter yhat3 score_startyr, msize(medium) legend(off)
pause
* reduce potential bias (increase variance) by restricting attention to observations around the cut-off
  
  reg score_endyr treat score_startyr if (score_startyr>=210 & score_startyr<=220)
  reg score_endyr treat score_startyr if (score_startyr>=212 & score_startyr<=218)
  reg score_endyr treat score_startyr if (score_startyr>=214 & score_startyr<=216)
  
* equivalent placebo tests using placebo treatments

  reg score_endyr plabo_treat1 score_startyr score_startyr2 score_startyr3
  reg score_endyr plabo_treat2 score_startyr score_startyr2 score_startyr3
  
 *close log file 
 log close