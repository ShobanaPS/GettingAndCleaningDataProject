# GettingAndCleaningDataProject
This repository has data and script used for the getting and cleaning data project on coursera

## run_analysis.R

The tidaydata.txt file attached can be read into R using the following command:
tbl_read <- read.table("TidyData.txt", header = TRUE)

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
 <li> Read all train and test data and bind the rows for subject, yand x.
 <li> Assign the right column names
 <li> The feature_name read earlier is used as the column names for all the observations read from x 
 <li> Restrict x data to a subset of mean and standard deviation (std) measurements 
 <li> Use subject, y and x data to create the full data set.
 <li> Use dplyr package, to convert the data to a table that can merge with the activity table to get activity_name
 <li> Re-order data and keep only required columns
 <li> From this data set, create a new tidy data set, that calculates the mean of every variable for every activity for each subject.
 </ol>
 
There are comments within the script itself which explain what each of the statements is trying to achieve.

The resulting tidy data set follows the following tidy data principles:
1. Each variable forms a column
2. Each observation forms a row
3. Each type of observational unit forms a table (For the purposes of this project,all the observations are in a single table)


References:
I found the post below that I got from the discussion forum extremely helpful - thanks thoughful bloke!
https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/
