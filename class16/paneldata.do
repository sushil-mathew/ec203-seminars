  cd " ... "

  use "...", clear

  reg slpnap d81 totwrk educ gdhlth marr yngkid

  reg slpnap d81 totwrk educ gdhlth marr yngkid, cluster(id)

  xtset id year
  xtreg slpnap d81 totwrk educ gdhlth marr yngkid, re

  sort id year
  by id: gen d_d81=d81[2]-d81[1] if _n==2
  by id: gen d_slpnap=slpnap[2]-slpnap[1] if _n==2
  by id: gen d_totwrk=totwrk[2]-totwrk[1] if _n==2
  by id: gen d_educ=educ[2]-educ[1] if _n==2
  by id: gen d_gdhlth=gdhlth[2]-gdhlth[1] if _n==2
  by id: gen d_marr=marr[2]-marr[1] if _n==2
  by id: gen d_yngkid=yngkid[2]-yngkid[1] if _n==2

  reg d_slpnap d_totwrk d_educ d_gdhlth d_marr d_yngkid
  
  xtreg slpnap d81 totwrk educ gdhlth marr yngkid, fe 
  
* note 1:   
  sort id year
  by id: gen DE_81=d81-(d81[2]+d81[1])/2 
  by id: gen DE_slpnap=slpnap-(slpnap[2]+slpnap[1])/2
  by id: gen DE_totwrk=totwrk-(totwrk[2]+totwrk[1])/2
  by id: gen DE_educ=educ-(educ[2]+educ[1])/2
  by id: gen DE_gdhlth=gdhlth-(gdhlth[2]+gdhlth[1])/2
  by id: gen DE_marr=marr-(marr[2]+marr[1])/2
  by id: gen DE_yngkid=yngkid-(yngkid[2]+yngkid[1])/2
    
  reg DE_slpnap DE_81 DE_totwrk DE_educ DE_gdhlth DE_marr DE_yngkid
	
* note 2:
  xi: reg slpnap d81 totwrk educ gdhlth marr yngkid i.id 

  
  xtreg slpnap d81 totwrk educ gdhlth marr yngkid, fe
  estimates store fe
  xtreg slpnap d81 totwrk educ gdhlth marr yngkid, re
  estimates store re
  hausman fe re

* 
  
  xtset id year
  reg slpnap d81 totwrk educ gdhlth marr yngkid
  outreg2 using reg_ex, replace ctitle(MODEL 1)
  reg slpnap d81 totwrk educ gdhlth marr yngkid, cluster(id)
  outreg2 using reg_ex, append ctitle(MODEL 2)
  xtreg slpnap d81 totwrk educ gdhlth marr yngkid, re
  outreg2 using reg_ex, append ctitle(MODEL 3)
  xtreg slpnap d81 totwrk educ gdhlth marr yngkid, fe
  outreg2 using reg_ex, append ctitle(MODEL 4)
  
  log close
  exit

 

