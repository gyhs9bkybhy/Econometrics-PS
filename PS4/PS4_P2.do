// Read data
clear
use "C:\Users\Yunhan Guo\Desktop\2023 Fall\P218 Econometrics1\Problem Sets\PS4\ccapm.dta"

// Generate lagged variables
gen cratio_1 = cratio[_n-1]
gen rrate_1 = rrate[_n-1]
gen e_1 = e[_n-1]

// a) GMM
gmm({beta=1}* (cratio^(-{gamma=1}))*rrate-1), inst(cratio_1 rrate_1 e_1)

// b) GMM with NW HAC
gen time=[_n]
gmm({beta=1}* (cratio^(-{gamma=1}))*rrate-1), inst(cratio_1 rrate_1 e_1) wmatrix(hac ba 5)