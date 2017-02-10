# GettingAndCleaningDataProject
This repository has data and script used for the getting and cleaning data project on coursera

## run_analysis.R
This is the script that performs the analysis required to complete the project. The script is written to achieve the following objectives:
<li> Extracts only the measurements on the mean and standard deviation for each measurement.
<li> Merges the training and the test sets to create one data set.
<li> Uses descriptive activity names to name the activities in the data set
<li> Appropriately labels the data set with descriptive variable names.
<li> From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The script assumes that the raw data required for the analysis has been downloaded and unzipped to a directory that has been set as the working directory from where the script will be run.

The script can be explained as follows:
<ol>
 <li> Read activity_labels.txt and assign headers of activity_id and activity_name to the data.
 <li> Read features.txt and assign headers of feature_id and feature_name to the data
 <li> Read all training data in the train folder and assign the right column names
  * The feature_name read earlier is used as the column names for all the observations read from x_train
  * The activity_name read earlier is used as the column names for all activity data read from y_train
 <li> Do the same for data under the test folder
 <li> A subset of x_train and x_test data that only holds the mean and std values are created
 <li> Combine Subject, x and y data for training data and add a label 'train' to identify this as training data 
 <li> Combine Subject, x and y data for testing data and add a label 'train' to identify this as training data 
 <li> Convert training and testing data to a table to use features of the dplyr package
 <li> Merge training and testing data using bind_rows to get full set of data
 <li> Transform data from wide form to narrow form,ie, convert all the measures in columns to rows
    <ul>
     <li>To do this, an empty table is created in the format that the narrow table would look like,ie,
      the table has only 5 columns:test_train, subject_id,activity_id,feature_id and observation
      <li>A for loop takes every column in the full data set that has observations in it and transforms data for every observation 
      into rows of that data.
      </ul> 
 <li> Merge the narrow table with the activity table created at the beginning of the process to get activity_names
 <li> Re-order data and keep only required columns
 <li> Create a table with the mean and standard variables along with the full descriptive name of the measures for example, 
      fBodyAcc-mean()-X = Mean of Frequency Domain for Body Acceleration on the X axis
 <li> Merge variables name data with our full data set to get full variable descriptions
 <li> Re-order data and keep only required columns
 <li> From this data set, create a new tidy data set, that calculates the mean of every variable for every activity for each subject.
 <li> Write data out to a file called TidyData.txt
 </ol>
 
There are comments within the script itself which explain what each of the statements is trying to achieve.
