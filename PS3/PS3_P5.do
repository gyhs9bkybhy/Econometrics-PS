// open log file
capture log close
log using "stata_template", replace text

// basic set-up
version 18
clear all
set more off
set linesize 80

// read files
cd "C:\Users\Yunhan Guo\Desktop\2023 Fall\P218 Econometrics1\Problem Sets\PS3"
import excel "PS4data.xls", sheet("data") firstrow clear

// 5 (a) Run AR(4) Regression
gen t = _n
tset t

gen C = realconsumptionofnondurables + realconsumptionofservices // level consumption
reg C L(1/4).C

gen C_pc = C / population // per capita consumption
reg C_pc L(1/4).C_pc

// 5 (c) 
gen C_pc_log = log(C_pc)
gen Y_pc = realdisposa`bleincome / population
gen Y_pc_log = log(Y_pc)

gen Y_pc_log_g0 = Y_pc_log - L1.Y_pc_log
gen C_pc_log_g0 = C_pc_log - L1.C_pc_log
gen C_pc_log_g2 = L2.C_pc_log - L3.C_pc_log
gen C_pc_log_g3 = L3.C_pc_log - L4.C_pc_log
gen C_pc_log_g4 = L4.C_pc_log - L5.C_pc_log
gen C_pc_log_g5 = L5.C_pc_log - L6.C_pc_log

ivregress 2sls C_pc_log_g0 (Y_pc_log_g0 = C_pc_log_g2 C_pc_log_g3 C_pc_log_g4 C_pc_log_g5), robust // 2sls



// 5 (d)

estat endogenous // endogenerity

gen res = C_pc_log_g0 - 0.0026129 - 0.4369272 * Y_pc_log_g0
reg res C_pc_log_g2 C_pc_log_g3 C_pc_log_g4 C_pc_log_g5