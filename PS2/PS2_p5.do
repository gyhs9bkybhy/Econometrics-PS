clear

// Parameters and variables
set seed 20231028
scalar beta = 0
scalar T = 100
matrix rhos = matrix(0, 0.5, 0.95)

matrix zetas = J(100, 1, 0)
matrix epsilons = J(100, 1, 0)
matrix y = J(100, 3, 0)
matrix x = J(100, 1, 1)

// Simulation
forvalues i = 1(1)100{
	matrix zetas[`i', 1] = rnormal()
}

forvalues j = 1(1)3{
	scalar rho = rhos[1, `j']
	forvalues i = 1(1)100{
		if `i' == 1 {
			matrix epsilons[`i', 1] = zetas[`i', 1]
		}
		else{
			matrix epsilons[`i', 1] = rho * epsilons[`i'-1, 1] + zetas[`i', 1]
		}
		matrix y[`i', `j'] = beta + epsilons[`i', 1]
	}
}

// OLS
svmat y
regress y1
regress y2
regress y3

// Newey-West
generate time = _n
tsset time
newey y1, lag(4)
newey y2, lag(4)
newey y3, lag(4)

// Compare the OLS resu;ts and the Newey-West results, we can see when serial corrlelation is stronger, Newey-West will hugely increase the standard error, so that the t-statistics decreases in magnitude. That means, the parameter that is significant in OLS may no longer be significant in Newey-west.