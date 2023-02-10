clear all
set obs 1000
gen x1 = _n/10
gen y = 20 + -2*x1 + rnormal(0,4) if x1 < 20
replace y = 80 + -2*x1 + rnormal(0,4) if x1 >= 20 & x1 < 40
replace y = 140 + -2*x1 + rnormal(0,4) if x1 >= 40 & x1 < 60
replace y = 200 + -2*x1 + rnormal(0,4) if x1 >= 60 & x1 < 80
replace y = 260 + -2*x1 + rnormal(0,4) if x1 >= 80 & x1 < 100
twoway (scatter y x1, msize(small) mcolor(black%80))(lfit y x1), legend(off) title("A rubbish model: y{subscript:i} = {&alpha} + {&beta}{subscript:1}x{subscript:1{subscript:i}}") ytitle("Y", size(large)) xtitle("X{subscript:1}", size(large)) name(nox2, replace)

*how does x2 predict x1?
*how does x2 predict y?
*how does x1 predict y unconditional on x2?
*how does x1 predict y conditional on x2?
twoway (scatter y x1 if x1 < 20, msize(small) mcolor(red*0.5)) ///
(scatter y x1 if x1 >= 20 & x1 < 40, msize(small) mcolor(red*1)) ///
(scatter y x1 if x1 >=40 & x1 < 60, msize(small) mcolor(red*1.5)) ///
(scatter y x1 if x1 >=60 & x1 < 80, msize(small) mcolor(red*2)) ///
(scatter y x1 if x1 > 80, msize(small) mcolor(red*2.5)), ///
legend(off) ///
xline(0(20)100, lpattern(dash)) ///
ytitle("y", size(vlarge)) xtitle("x{subscript:1}", size(vlarge)) ///
title("Adding 5 new dummy variables, for a variable X{subscript:2} with 5 categories (for ex: 5 regions in the UK)", size(small)) ///
text(75 10 "x{subscript:2} = 1", color(red*0.5)) ///
text(75 30 "x{subscript:2} = 2", color(red*1)) ///
text(75 50 "x{subscript:2} = 3", color(red*1.5)) ///
text(30 70 "x{subscript:2} = 4", color(red*2)) ///
text(30 90 "x{subscript:2} = 5", color(red*2.5)) ///
name(addedx2, replace)

egen x2 = cut(x1), at(0,20,40,60,80,101)
reg y i.x2 
predict residy, residuals
reg x1 i.x2 
predict residx, residuals
twoway (scatter residy residx if x2 == 0, mcolor(red*0.5)) ///
(scatter residy residx if x2 == 20, mcolor(red*1)) ///
(scatter residy residx if x2 == 40, mcolor(red*1.5)) ///
(scatter residy residx if x2 == 60, mcolor(red*2)) ///
(scatter residy residx if x2 == 80, mcolor(red*2.5)) ///
, ytitle("y|x{subscript:2}", size(vlarge)) xtitle("x{subscript:1}|x{subscript:2}", size(vlarge)) ///
title("What controlling for a variable looks like visually") ///
subtitle("Notice the axes scale and colour of dots.""Compare this to Fig2 colours") ///
name(controlz1, replace) legend(off)

egen x3 = cut(x1), at(0(5)101)
reg y i.x3 
predict residy2, residuals
reg x1 i.x3
predict residx2, residuals
twoway (scatter y x1 if x3 == 0, msize(small)) ///
(scatter y x1 if x3 == 5, msize(small)) ///
(scatter y x1 if x3 == 10, msize(small)) ///
(scatter y x1 if x3 == 15, msize(small)) ///
(scatter y x1 if x3 == 20, msize(small)) ///
(scatter y x1 if x3 == 25, msize(small)) ///
(scatter y x1 if x3 == 30, msize(small)) ///
(scatter y x1 if x3 == 35, msize(small)) ///
(scatter y x1 if x3 == 40, msize(small)) ///
(scatter y x1 if x3 == 45, msize(small)) ///
(scatter y x1 if x3 == 50, msize(small)) ///
(scatter y x1 if x3 == 55, msize(small)) ///
(scatter y x1 if x3 == 60, msize(small)) ///
(scatter y x1 if x3 == 65, msize(small)) ///
(scatter y x1 if x3 == 70, msize(small)) ///
(scatter y x1 if x3 == 75, msize(small)) ///
(scatter y x1 if x3 == 80, msize(small)) ///
(scatter y x1 if x3 == 85, msize(small)) ///
(scatter y x1 if x3 == 90, msize(small)) ///
(scatter y x1 if x3 == 95, msize(small)), ///
legend(off) ///
xline(0(5)100, lpattern(dash)) ///
ytitle("y", size(vlarge)) xtitle("x{subscript:1}", size(vlarge)) ///
title("Adding a variable X{subscript:3} with 20 (irrelevant) categories") ///
name(addedx3, replace)

twoway (scatter residy2 residx2 if x3 == 0) ///
(scatter residy2 residx2 if x3 == 5)  ///
(scatter residy2 residx2 if x3 == 10) ///
(scatter residy2 residx2 if x3 == 15) ///
(scatter residy2 residx2 if x3 == 20) ///
(scatter residy2 residx2 if x3 == 25) ///
(scatter residy2 residx2 if x3 == 30) ///
(scatter residy2 residx2 if x3 == 35) ///
(scatter residy2 residx2 if x3 == 40) ///
(scatter residy2 residx2 if x3 == 45) ///
(scatter residy2 residx2 if x3 == 50) ///
(scatter residy2 residx2 if x3 == 55) ///
(scatter residy2 residx2 if x3 == 60) ///
(scatter residy2 residx2 if x3 == 65) ///
(scatter residy2 residx2 if x3 == 70) ///
(scatter residy2 residx2 if x3 == 75) ///
(scatter residy2 residx2 if x3 == 80) ///
(scatter residy2 residx2 if x3 == 85) ///
(scatter residy2 residx2 if x3 == 90) ///
(scatter residy2 residx2 if x3 == 95) ///
, ytitle("y|x{subscript:3}", size(vlarge)) xtitle("x{subscript:1}|x{subscript:3}", size(vlarge)) ///
title("What controlling for a an irrelevant variable looks like visually") ///
subtitle("The slope is still the same" "But the uncertainty in the slope has increased" "Also compare scale of y and x axis with fig3") ///
name(controlz2, replace) legend(off)





