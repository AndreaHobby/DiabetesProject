/************************************************************************************************************************/
/* Filename: 1-DataCleanManipDiabetes                                                                                             */
/*                             Goal:                                                                                    */                    */
/* Contents:                                                                                                            */
/* -Data Cleaning                                                                                                                 */
/* -Data Manipulation																									*/
/*                                                                                                                      */
/*                                                                                                                      */
/* Date Created: 2019-05-28-2019                                                                                             */
/* Date Updated: 2019-05-28-2019                                                                                             */
/* Program Author: Andrea Hobby                                                                                         */
/* Version 1.0                                                                                                          */
/************************************************************************************************************************/


*Import Data Set*
LIBNAME diabetic  'C:\Users\adh81\Desktop\';

DATA diabetic.diabetes;
	LENGTH race $22.;
	INFILE "C:\Users\adh81\Desktop\diabetic_datarev1.csv" delimiter=',' firstobs=2 
                 lrecl = 101767;
	INPUT encounter_id patient_nbr race $	gender $	age $ time_in_hospital num_lab_procedures	num_procedures	num_medications	
number_outpatient	number_emergency	number_inpatient number_diagnoses	change $	diabetesMed	$ readmitted $;
RUN;

proc contents data=diabetic.diabetes; /*Verify Number of Observations and variable type and length*/
run;

proc freq data=diabetic.diabetes;
tables race gender age change diabetesMed	readmitted / nocum nopercent;
title "Frequency Counts for Character Variables";
run;

*Checking to make sure character variables and numeric variables are valid*
title "Listing of invalid character values";
data _null_;
set diabetic.diabetes;
file print; 
***check Gender for invalid or missing data;
if Gender not in ('Female' 'Male' ' ') then put Gender=;
run;

title "Listing of invalid gender values";
proc print data=diabetic.diabetes;
where Gender not in ('Male' 'Female' ' ');
id patient_nbr;
var Gender;
run;

*Checking for invalid numeric variables*
title "Checking numeric variables in the diabetes data set";
proc means data=diabetic.diabetes n nmiss min max maxdec=3;
var encounter_id patient_nbr time_in_hospital num_lab_procedures num_procedures	num_medications	
number_outpatient	number_emergency	number_inpatient number_diagnoses;
run;

/*Then, I looked for out of range data and overall range of the data.*/

title "Using PROC UNIVARIATE to Look for Outliers";
proc univariate data=diabetic.diabetes plot;
id patient_nbr;
var time_in_hospital num_lab_procedures num_procedures	num_medications	
number_outpatient	number_emergency	number_inpatient number_diagnoses;
run;

ods select extremeobs;
title "Using proc univariate to look for outliers";
proc univariate data=diabetic.diabetes;
id patient_nbr;
var time_in_hospital num_lab_procedures num_procedures	num_medications	
number_outpatient	number_emergency	number_inpatient number_diagnoses;
run;

/*I looked for duplicates and values that are repeating. The ecounter_id is unique for every visit.*/
proc sort data=diabetic.diabetes out=tmp;
by encounter_id;
run;

data dup;
set tmp;
by encounter_id;
if first.encounter_id and last.encounter_id then delete;
run;

title "Listing of duplicates from data set diabetic.diabetes";
proc print data=dup;
id encounter_id;
run; 

*Relabel and format variables as needed. This mainly for the age variable and medications.* 





