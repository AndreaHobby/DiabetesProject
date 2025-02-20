![diabetes](img/Diabetes.PNG)

### Objective
This is a project to analyze hospital readmission in 130-US hospitals for years 1999-2008. 

### Hypothesis 
Number of Hospital of diagnoses, # of procedures, # of inpatient visits, medication change, and number of emergency visits are associated with hospital readmission. 

### Step 1 Obtaining the data

Once the individual dataset was downloaded, I used excel to remove variables that would not be used. 
Payer code and weight were variables of interest but were moved due to a high level of missing data. 
Then, I checked the variable types in **SAS 9.4**.
 
### Step 2 Data Cleaning and Manipulation 
 I checked for invalid character values and missing data. Then, I looked for out of range data. 
 I checked for invalid numeric values and missing data. I checked to see if any data types need to be converted. Last, I checked the range for variables. I looked for duplicates and values that are repeating. The race variable had a signficant level of missing data butI kept it in the data set. 

### Step 3 Data Modeling 

The continuous variables used for time in hospital, # of lab procedures, # of procedures, # of medications, # of outpatient visits, # of emergency visits, # of admissions, # of inpatient visits, and # of diagnoses. 

The categorical variables used were age, race, gender, readmission, diabetes medication and medication change.

Since this is healthcare utilization data, I wanted to learn the spread of the variables of interest that will be used in the model. 
I have created histogram that showed the skewness of the variables of interest. 

Also, I ran descriptive statistics for my variables of interest. I checked the Mean, Medium, Mode and n for variables of interest. 

Significance tests were used to identify the associations between each variable and the outcome. For categorical variables, the chi square test was used or Fisher exact test where appropriate. For continuous variables, the Mann-Whitney U test was used. 

Logistic regression was used for data modeling. 

### Conclusion

A one unit increase in time in hospital, the odds of being readmitted to the hospital (versus no readmission) increase by a factor of 1.05.

### Source:

The data are submitted on behalf of the Center for Clinical and Translational Research, Virginia Commonwealth University, a recipient of
NIH CTSA grant UL1 TR00058 and a recipient of the CERNER data. John Clore (jclore '@' vcu.edu), Krzysztof J. Cios (kcios '@' vcu.edu), 
Jon DeShazo (jpdeshazo '@' vcu.edu), and Beata Strack (strackb '@' vcu.edu). 
This data is a de-identified abstract of the Health Facts database (Cerner Corporation, Kansas City, MO).

## Repo Structure
```
├── /data (diabetes data)
├── /img (contains all images for repo)
├── 1-DataCleanManipDiabetes.sas
├── 2-DataModelingDiabetes.sas
├── README.md
└── dataset_diabetes.zip



