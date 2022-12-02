clear

/*
File:	cepr_acs_ew_2016-21_tables.do
Date:	01 Dec 2022
Desc:	ACS tables for expert witness statement calculations

*/

/* set directories */

/* dropbox - pandeMAC deux */

global do "/Users/glooper/Dropbox (CEPR)/Data/homestata/projects/disability/do/2022_expertwitness_ACS" /* do files */
global raw "/Users/glooper/Dropbox (CEPR)/Data/homestata/projects/disability/data/raw" /* ipums extracts */
global working "/Users/glooper/Dropbox (CEPR)/Data/homestata/projects/disability/data/working" /* recoded extracts */
global log "/Users/glooper/Dropbox (CEPR)/Data/homestata/projects/disability/log/2022_expertwitness_ACS" /* log files */

cd "$working"
use "ipums_acs_2016-2021_disability_recode.dta"

cd "$log"
log using cepr_tables_ew_2016-2021.log, replace


					/* employment-to-population ratio (epop) */
			
/* disabled epop by state, ages 21 to 64 */
tab statefip epop [aw=rndwt] if disability==1 & agewk==1 & inst==0, row nofreq

/* all epop by state, ages 21 to 64 */
tab statefip epop [aw=rndwt] if agewk==1 & inst==0, row nofreq

/* Disabled epop by state by year, ages 21 to 64  */
bysort year: tab statefip epop [aw=perwt] if disability==1 & agewk==1 & inst==0, row nofreq

/* all epop by state by year, ages 21 to 64 */
bysort year: tab statefip epop [aw=perwt] if agewk==1 & inst==0, row nofreq

log close
