This code extracts and tidies the HAR dataset.
The code sequence is roughly like this:

* read the initial data
  * load in the measured values
  * combine them
* use only the mean or std data measurements
  * load the feature names
  * extract those which are 'mean' or 'std'
  * use them to extract only those columns
* get the activities
  * get the indices and combine them correctly
  * get the names
  * label both datasets
  * apply a join to select them out
  * add them as a new vector to the working data
* get the subjects
 * get the data files and combine them correctly
 * add them as a new vector to the working data
* compute the average per subject and activity
  * melt the data into long form
  * cast the data back into wide, applying mean() to aggregate them
* pretty up the names
 * use a sequence of regex substitutions to format the names
* save the data as a CSV file

