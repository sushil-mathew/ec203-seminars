*********************
* some guidance on Stata code
*********************

  des

  reg narr86 ptime86 qemp86 pcnv avgsen black hispan

  capture drop arr
  gen arr=.
  replace arr=1 if narr86>0
  replace arr=0 if narr86==0
  ta arr
  
* * * * * * Aside * * * * * * * * 
 gen arr_v2 = narr86>0
 tab arr_v2
* * * * * * * * * * * * * * * * * 

  reg arr ptime86 qemp86 pcnv avgsen black hispan
  
  reg arr ptime86 qemp86 pcnv avgsen black hispan
  capture drop yhat
  predict yhat  // generate the predicted values
  sum yhat, d
  count if (yhat<0 | yhat>1)
  
  reg arr ptime86 qemp86 pcnv avgsen black hispan
  capture drop resid   // generate the residuals
  predict resid, resid
  histogram resid

  reg arr ptime86 qemp86 pcnv avgsen black hispan
  estat hettest ptime86 qemp86 pcnv avgsen black hispan, fstat

* running the above test manually:

  reg arr ptime86 qemp86 pcnv avgsen black hispan
  capture drop resid
  predict resid, residuals  // generate the residuals
  capture drop resid2
  gen resid2=resid^2  // square the residuals
  reg resid2 ptime86 qemp86 pcnv avgsen black hispan
  test ptime86 qemp86 pcnv avgsen black hispan


  reg arr ptime86 qemp86 pcnv avgsen black hispan   // non-robust s.e.s
  reg arr ptime86 qemp86 pcnv avgsen black hispan, robust  // robust s.e.s

  display -0.0240885/0.0028618

  
  log close
