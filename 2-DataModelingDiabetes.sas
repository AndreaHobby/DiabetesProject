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




*Import Data Set*
LIBNAME diabetic  'C:\Users\adh81\Desktop\';

DATA diabetic.diabetes;
	LENGTH race $22.;
	INFILE "C:\Users\adh81\Desktop\diabetic_datarev1.csv" delimiter=',' firstobs=2 
                 lrecl = 101767;
	INPUT encounter_id patient_nbr race $	gender $	age $ time_in_hospital num_lab_procedures	num_procedures	num_medications	
number_outpatient	number_emergency	number_inpatient number_diagnoses	change $	diabetesMed	$ readmitted $;
RUN;

/*I have created several histograms to better understand the spread of variables of interest.*/

PROC SGPLOT DATA = diabetic.diabetes;
 HISTOGRAM time_in_hospital;
 title 'Diabetes Time in Hospital Histogram';
RUN; 

PROC SGPLOT DATA = diabetic.diabetes;
 HISTOGRAM num_lab_procedures;
 title 'Diabetes # of Lab Procedures Histogram';
RUN; 

PROC SGPLOT DATA = diabetic.diabetes;
 HISTOGRAM num_procedures;
 title 'Diabetes # of Procedures Histogram';
RUN; 

PROC SGPLOT DATA = diabetic.diabetes;
 HISTOGRAM num_medications;
 title 'Diabetes # of Medications Histogram';
RUN; 

PROC SGPLOT DATA = diabetic.diabetes;
 HISTOGRAM  number_outpatient;
 title 'Diabetes # of Outpatient Visits Histogram';
RUN; 

PROC SGPLOT DATA = diabetic.diabetes;
 HISTOGRAM number_emergency;
 title 'Diabetes # of Emergency Room Visits Histogram';
RUN;

PROC SGPLOT DATA = diabetic.diabetes;
 HISTOGRAM number_inpatient;
 title 'Diabetes # of Inpatient Room Visits Histogram';
RUN;

PROC SGPLOT DATA = diabetic.diabetes;
 HISTOGRAM number_diagnoses;
 title 'Diabetes # of Diagnoses Visits Histogram';
RUN;


proc gchart data=diabetic.diabetes;
	vbar gender;
	title 'Diabetes Gender Bar Chart';
run;

proc gchart data=diabetic.diabetes;
	vbar race;
	title 'Diabetes Race Bar Chart';
run;

proc gchart data=diabetic.diabetes;
	vbar age;
	title 'Diabetes Age Bar Chart';
run;

proc gchart data=diabetic.diabetes;
	vbar change;
	title 'Diabetes Medication Change Bar Chart';
run;

proc gchart data=diabetic.diabetes;
	vbar diabetesMed;
	title 'On Diabetes Medication Bar Chart';
run;

proc gchart data=diabetic.diabetes;
	vbar readmitted ;
	title 'Diabetes Hospital Readmmision Bar Chart';
run;

/*I ran descriptive statistics(Mean/Medium/Mode/n) for my variables of interest.*/

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


