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
*Before importing, I dropped the weight variable due to a significant amount of missing data* 
LIBNAME diabetic  'C:\Users\User\Desktop\DataAnal\';

DATA diabetic.diabetes;
	INFILE "C:\Users\User\Desktop\DataAnal\diabetic_data.csv";
	INPUT encounter_id	patient_nbr	race $	gender $	age $	weight	admission_type_id	discharge_disposition_id	
admission_source_id	time_in_hospital	payer_code	medical_specialty $	num_lab_procedures	num_procedures	num_medications	
number_outpatient	number_emergency	number_inpatient	diag_1	diag_2	diag_3	number_diagnoses	max_glu_serum	
A1Cresult	$ metformin	$ repaglinide $	nateglinide	$ chlorpropamide $ glimepiride	$ acetohexamide	$ glipizide	$ glyburide	$ tolbutamide $
pioglitazone $	rosiglitazone $	acarbose $	miglitol $	troglitazone $	tolazamide $	examide $	citoglipton	$ insulin $	
glyburide_metformin $	glipizide_metformin	$ glimepiride_pioglitazone $	metformin_rosiglitazone $	metformin_pioglitazone $	change $	
diabetesMed	$ readmitted $
;
RUN;

proc contents data=diabetic.diabetes;
run;

proc freq data=diabetic.diabetes;
tables race gender age / nocum nopercent;
title "Frequency Counts for Selected Character Variables";
run;


*Checking to make sure character variables and numeric variables are valid*
title "Listing of invalid character values";
data _null_;
set diabetic.diabetes;
file print; 
***check Gender;
if Gender not in ('F' 'M' ' ') then put Patno= Gender=;
***check Dx;
if verify(trim(Dx),'0123456789') and not missing(Dx)
then put Patno= Dx=;
if AE not in ('0' '1' ' ') then put Patno= AE=;
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
var encounter_id patient_nbr;
run;

*Check for Missing Data*

/*Then, I looked for out of range data.*/

title "Using PROC UNIVARIATE to Look for Outliers";
proc univariate data=diabetic.diabetes plot;
id patient_nbr;
var encounter_id patient_nbr;
run;

ods select extremeobs;
title "Using proc univariate to look for outliers";
proc univariate data=diabetic.diabetes;
id Patno;
var HR SBP DBP;
run;

title "Out-of-range values for numeric variables";
proc print data=clean.patients;
where (HR not between 40 and 100 and HR is not missing) or
(SBP not between 80 and 200 and SBP is not missing) or
(DBP not between 60 and 120 and DBP is not missing);
id Patno;
var HR SBP DBP;
run;

I checked to see if any data types need to be converted. 

Last, I checked the range for variables. 

/*I looked for duplicates and values that are repeating.*/
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

proc format;
invalue $gen 'F','M' = _same_
other = ' ';
invalue $ae '0','1' = _same_
other = ' ';
run;

data clean.patients_filtered;
infile "c:\books\clean\patients.txt" pad;
input @1 Patno $3.
@4 Gender $gen1.
@27 AE $ae1.;
label Patno = "Patient Number"
Gender = "Gender"
AE = "adverse event?";
run;

title "Listing of data set PATIENTS_FILTERED";
proc print data=clean.patients_filtered;
var Patno Gender AE;
run;



