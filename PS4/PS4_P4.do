// Read data
clear
use "C:\Users\Yunhan Guo\Desktop\2023 Fall\P218 Econometrics1\Problem Sets\PS4\MURDER.dta"
// a) 
reg mrdrte exec unem d90 d93


// b)
xtset id year
xtreg mrdrte exec unem d90 d93, fe
mat betafe = get(_b)
mat Vfe = get(VCE)

// c)
xi: qui reg mrdrte i.id
predict rmrdrte, residuals
xi: qui reg exec i.id
predict rexec, residuals
xi: qui reg unem i.id
predict runem, residuals
xi: qui reg d90 i.id
predict rd90, residuals
xi: qui reg d93 i.id
predict rd93, residuals

reg rmrdrte rexec runem rd90 rd93, noconstant

// d)
xtreg mrdrte exec unem d90 d93
mat betare = get(_b)
mat Vre = get(VCE)
mat hausman=(betafe[1,1..4]-betare[1,1..4])*invsym(Vfe[1..4,1..4]-Vre[1..4,1..4])*(betafe[1,1..4]-betare[1,1..4])'
mat list hausman