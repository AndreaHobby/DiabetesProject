/************************************************************************************************************************/
/* Filename: 2-DataModelingDiabetes                                                                                             */
/*                             Goal:                                                                                    */                    */
/* Contents:                                                                                                            */
/* -Data Modeling                                                                                                                */
/* 																									*/
/*                                                                                                                      */
/*                                                                                                                      */
/* Date Created: 2019-05-28-2019                                                                                             */
/* Date Updated: 2019-05-28-2019                                                                                             */
/* Program Author: Andrea Hobby                                                                                         */
/* Version 1.0                                                                                                          */
/************************************************************************************************************************/



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

/*I have created histogram to better understand the spread of variables of interest.*/
PROC SGPLOT DATA = sasdata.death;
 HISTOGRAM age;
 title 'Analysis of Survival - Age Histogram';
RUN; 

/*Also, I ran descriptive statistics(Mean/Medium/Mode/n) for my variables of interest.
*/

title "Descriptive Statitsics for Variables";
proc means data=diabetic.diabetes n nmiss mean median mode maxdec=3;
var admission_type_id;
run;

/*Significance tests were used to identify the associations between each variable and the outcome. 
For categorical variables, the chi square test was used or Fisher exact test where appropriate. */


proc freq data=datasetname;
 tables catvarrow*catvarcol / chisq measures
 plots=(freqplot(twoway=groupvertical scale=percent));
run;



/*The Kaplan-Meier life table method was used to estimate the risk of readmission. The log-rank test 
was used to compare survival curves. */
title 'Survival of Patients with Diabetes';
   data diabetic.diabetes;
      keep Freq Years Censored;
      retain Years -.5;
      input fail withdraw @@;
      Years + 1;
      Censored=0;
      Freq=fail;
      output;
      Censored=1;
      Freq=withdraw;
      output;
run;

  ods graphics on;
   proc lifetest data=Males  method=lt intervals=(0 to 15 by 1)
                 plots=(s,ls,lls,h,p);
      time Years*Censored(1);
      freq Freq;
   run;
   ods graphics off;


