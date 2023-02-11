
  cd "..."

  log using "...", replace

*  use bwght.dta, clear
  gen lbwght=ln(bwght)
  reg lbwght packs

  reg packs cigprice

  ivregress 2sls lbwght (packs=cigprice)

* Use new card.dta dataset: 
*  use card.dta, clear

  reg lwage educ exper expersq black smsa south smsa66 reg661-reg669
  reg educ nearc4 exper expersq black smsa south smsa66 reg661- reg669

  ivregress 2sls lwage (educ=nearc4) exper expersq black smsa south smsa66 reg661-reg669
  
  reg educ nearc4 exper expersq black smsa south smsa66 reg661-reg669
  predict educ_hat

  reg lwage educ_hat exper expersq black smsa south smsa66 reg661-reg669

  log close
  exit
