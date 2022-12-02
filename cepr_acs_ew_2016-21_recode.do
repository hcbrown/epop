clear

/*
File:	cepr_acs_ew_2016-21_recode.do
Date:	01 Dec 2022
Desc:	ACS recode for expert witness statement calculations

*/


/* set directories */

/* dropbox - pandeMAC deux */

global do "/Users/glooper/Dropbox (CEPR)/Data/homestata/projects/disability/do/2022_expertwitness_ACS" /* do files */
global raw "/Users/glooper/Dropbox (CEPR)/Data/homestata/projects/disability/data/raw" /* ipums extracts */
global working "/Users/glooper/Dropbox (CEPR)/Data/homestata/projects/disability/data/working" /* recoded extracts */
global log "/Users/glooper/Dropbox (CEPR)/Data/homestata/projects/disability/log/2022_expertwitness_ACS" /* log files */

cd "$raw"
use ipums_acs_ew_2016-2021.dta

/* general label for dummy variables */
lab def noyes 0 No 1 Yes

/* Round weights */
gen rndwt=round(perwt/6,1)

			/* Age */
gen byte agewk=0
replace agewk=1 if inrange(age, 21, 64)
lab var agewk "Ages 21–64"
lab val agewk noyes

			/* Group Quarters */
gen byte grpq=0
replace grpq=1 if inrange(gq, 3, 5)
lab var grpq "Group quarters"
lab val grpq noyes

gen byte inst=0
replace inst=1 if gq==3
lab var inst "Institionalized"
lab val inst noyes

			/* DISABILITY */

		/* recoded disability dummy variables to use 0 and 1 */
		
/* hearing */
recode diffhear (1=0 "no") (2=1 "yes"), gen(disear)
lab var disear "Hearing difficulty"

/* vision */
recode diffeye (1=0 "no") (2=1 "yes"), gen(diseye)
lab var diseye "Vision difficulty"

/* cognitive */
recode diffrem (1=0 "no") (2=1 "yes"), gen(discog)
lab var discog "Cognitive difficulty"

/* ambulatory */
recode diffphys (1=0 "no") (2=1 "yes"), gen(disamb)
lab var disamb "Ambulatory difficulty"

/* independent living */
recode diffmob (1=0 "no") (2=1 "yes"), gen(disind)
lab var disind "Independent living difficulty"

/* personal care */
recode diffcare (1=0 "no") (2=1 "yes"), gen(discare)
lab var discare "Personal care difficulty"

/* any disability */
gen byte disability=.
replace disability=0 if diffhear==1 & diffeye==1 & diffrem==1 & diffphys==1 & diffmob==1 & diffcare==1
replace disability=1 if diffhear==2 | diffeye==2 | diffrem==2 | diffphys==2 | diffmob==2 | diffcare==2
lab var disability "Any difficulty"
lab val disability noyes



			/* WORK */

/* labor force status - consolidated categories */
gen lfstat=. if empstat~=.
	replace lfstat=1 if empstat==1
	replace lfstat=2 if empstat==2
	replace lfstat=3 if empstat==3
lab var lfstat "Labor-force status"
#delimit ;
	lab def lfstat
	1 "Employed"
	2 "Unemployed"
	3 "NILF"
	;
#delimit cr
lab val lfstat lfstat

/* employed */
gen byte employed=0 if inlist(lfstat, 1, 2)
replace employed=1 if lfstat==1
lab var employed "Employed (ILF only)"
lab val employed noyes

/* EPOP */
recode lfstat (1=1 "employed") (2/3=0 "unemployed or NILF"), gen(epop)

/* wisconsin */
gen byte wisconsin=.
replace wisconsin=0 if inrange(statefip, 1, 56)
replace wisconsin=1 if statefip==55
lab var wisconsin "Wisconsin resident"
lab val wisconsin noyes


cd "$working"
saveold "ipums_acs_2016-2021_disability_recode.dta", replace


