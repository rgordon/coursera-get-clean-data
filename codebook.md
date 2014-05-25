Codebook for Extracted Data
===========================

This dataset (tidydata.csv) is extracted from the UCH HAR dataset published with this reference:

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

The source dataset was obtained from [UCH HAR dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

The data is organized by subject, activity, and the series of measurements that you can find further in the "feature_info.txt" of the original dataset.

In this specific dataset, to meet project requirements, the "mean or stddev" of measurements were extracted and averaged for each subject and activity.

### Identity Values:
* Subject: range 1-30, uniquely identifies the subject
* Activity:
  * WALKING
  * SITTING
  * STANDING
  * LAYING
  * WALKING_DOWNSTAIRS
  * WALKING_UPSTAIRS

### Variables
remaining columns are the average of all values of that type.
Naming scheme used: I used the original names from feature_info.txt and expanded them, 
made them a little more readable. They map directly into the original names and I'm not 
going to repeat that here.

### Notes
There's some interpretation of the measures to be used - I explicitly included the "mean freq" measurements because they seemed to loosely fall into the "mean of measurement" requirement.
I explicitly excluded the mean of angle between vectors, because these appeared to be derived 
values and not of the original measurement.
Frankly the requirements were somewhat vague - if I was doing this for a customer I'd just ask them whether they wanted it included or not.

