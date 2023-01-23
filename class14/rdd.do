  codebook  
  sum 
  sum score_startyr, d
  sum score_endyr, d
  ta cutoff
  ta treat 
  sum score_startyr if treat==1, d
  sum score_endyr if treat==0, d
  ttest score_endyr, by(treat)
 
 
* graphical analysis: best place to start with rd designs
 
  set scheme sj
  
  scatter score_endyr score_startyr, xline(215) 
  
  scatter score_endyr score_startyr if score_startyr<215, xline(215) ///
  msymbol(Oh) msize(vsmall) || scatter score_endyr score_startyr ///
  if score_startyr>=215, xline(215) msymbol(O) msize(vsmall)
  
  reg score_endyr score_startyr treat
  
  reg score_endyr treat score_startyr 
  predict yhat 
  twoway scatter score_endyr score_startyr || scatter yhat score_startyr, msize(medium)
  
* balancing tests to check "quasi-randomisation"

  ttest age, by(treat)
  ttest age if (score_startyr>=213 & score_startyr<=217), by(treat)
  
  ttest male, by(treat)
  ttest male if (score_startyr>=213 & score_startyr<=217), by(treat)
 
  ttest frlunch, by(treat)
  ttest frlunch if (score_startyr>=213 & score_startyr<=217), by(treat)
  
  ttest white, by(treat)
  ttest white if (score_startyr>=213 & score_startyr<=217), by(treat)
  
* local regression techniques: exploratory analysis 
  
  twoway scatter score_endyr score_startyr if score_startyr<215, xline(215) ///
  msymbol(Oh) msize(vsmall) || scatter score_endyr score_startyr ///
  if score_startyr>=215, xline(215) msymbol(O) msize(vsmall) ///
  || lowess score_endyr score_startyr if score_startyr<215 ///
  || lowess score_endyr score_startyr if score_startyr>=215 
  
* placebo analysis 1: 210 cut-off
  twoway scatter score_endyr score_startyr if score_startyr<210, xline(210) ///
  msymbol(Oh) msize(vsmall) || scatter score_endyr score_startyr ///
  if score_startyr>=210, xline(210) msymbol(O) msize(vsmall) ///
  || lowess score_endyr score_startyr if score_startyr<210 ///
  || lowess score_endyr score_startyr if score_startyr>=210 
 
* placebo analysis 2: 220 cut-off
  twoway scatter score_endyr score_startyr if score_startyr<220, xline(220) ///
  msymbol(Oh) msize(vsmall) || scatter score_endyr score_startyr ///
  if score_startyr>=220, xline(220) msymbol(O) msize(vsmall) ///
  || lowess score_endyr score_startyr if score_startyr<220 ///
  || lowess score_endyr score_startyr if score_startyr>=220 

* fitting a regression to data: 
  reg score_endyr treat score_startyr 
  predict yhat 
  twoway scatter score_endyr score_startyr if score_startyr<215, xline(215) ///
  msymbol(Oh) msize(vsmall) || scatter score_endyr score_startyr ///
  if score_startyr>=215, xline(215) msymbol(O) msize(vsmall) ///
  || lowess score_endyr score_startyr if score_startyr<215 ///
  || lowess score_endyr score_startyr if score_startyr>=215 ///
  || scatter yhat score_startyr, msize(medium) 
  
  reg score_endyr treat score_startyr score_startyr2 score_startyr3
  predict yhat2 
  twoway scatter score_endyr score_startyr if score_startyr<215, xline(215) ///
  msymbol(Oh) msize(vsmall) || scatter score_endyr score_startyr ///
  if score_startyr>=215, xline(215) msymbol(O) msize(vsmall) ///
  || lowess score_endyr score_startyr if score_startyr<215 ///
  || lowess score_endyr score_startyr if score_startyr>=215 ///
  || scatter yhat2 score_startyr, msize(medium) 

* fully interactive model
  reg score_endyr treat score_startyr_215 score_startyr2_215 score_startyr3_215 ///
  score_startyr_215_T score_startyr2_215_T score_startyr3_215_T
  predict yhat3 
  twoway scatter score_endyr score_startyr if score_startyr<215, xline(215) ///
  msymbol(Oh) msize(vsmall) || scatter score_endyr score_startyr ///
  if score_startyr>=215, xline(215) msymbol(O) msize(vsmall) ///
  || lowess score_endyr score_startyr if score_startyr<215 ///
  || lowess score_endyr score_startyr if score_startyr>=215 ///
  || scatter yhat3 score_startyr, msize(medium) 
    
* reduce potential bias (increase variance) by restricting attention to 
* observations around the cut-off
  
  reg score_endyr treat score_startyr if (score_startyr>=210 & score_startyr<=220)
  reg score_endyr treat score_startyr if (score_startyr>=212 & score_startyr<=218)
  reg score_endyr treat score_startyr if (score_startyr>=214 & score_startyr<=216)
  
* equivalent placebo tests using placebo treatments

  reg score_endyr plabo_treat1 score_startyr score_startyr2 score_startyr3
  reg score_endyr plabo_treat2 score_startyr score_startyr2 score_startyr3
  