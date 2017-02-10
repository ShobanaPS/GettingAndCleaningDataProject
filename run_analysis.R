# Read activity_labels.txt
activity <- read.delim("activity_labels.txt", header = FALSE, sep = " ")
# assign column names
names(activity) <- c("activity_id", "activity_name")

#Read features.txt and assign column names
features <- read.delim("features.txt", header = FALSE, sep = " ")
names(features) <- c("feature_id", "feature_name")
# Read subject_train_data
subject_train <- read.csv("train/subject_train.txt", header = FALSE, sep = "")

#Assign column name for subject data
names(subject_train) <- c("subject_id")

#Read x_train data
x_train <- read.csv("train/x_train.txt", header = FALSE, sep = "")

#Assign column names for x_train data using feature names
names(x_train) <- features$feature_name

# Read y-train data
y_train <- read.csv("train/y_train.txt", header = FALSE, sep = "")

#Name the column as activity_id as this represents the 6 different activities
names(y_train) <- c("activity_id")

## do the same for test data ##
## Read subject_test data
subject_test <- read.csv("test/subject_test.txt", header = FALSE, sep = "")
names(subject_test) <- c("subject_id")

#Read x_test data
x_test <- read.csv("test/x_test.txt", header = FALSE, sep = "")

#Assign column names for x_test data using feature names
names(x_test) <- features$feature_name

# Read y-test data
y_test <- read.csv("test/y_test.txt", header = FALSE, sep = "")

#Name the column as activity_id as this represents the 6 different activities
names(y_test) <- c("activity_id")

#2.Extracts only the measurements on the mean and standard deviation for each measurement.
#subset of features that are only the mean and std of the observations
features_mean_std <- grep("(.mean\\(\\).)|(.std\\(\\).)",features$feature_name, value = TRUE)

#create a subset of x_train data that only has mean & std observations
x_train_mean_std <- x_train[features_mean_std]

# join subject, y and x data to get full training data
train_full <- c(subject_train,y_train,x_train_mean_std)

# add a label called 'Train' to denote training data
train_full$train_test <- replicate(7352, "Train")

#create a subset of x_test data that only has mean & std observations
x_test_mean_std <- x_test[features_mean_std]

# join subject, y and x data to get full testing data
test_full <- c(subject_test,y_test,x_test_mean_std)

# add a label called 'test' to denote testing data
test_full$train_test <- replicate(2947, "test")

library(dplyr)
# convert dataframes to tables
tbl_train <- tbl_df(train_full)
tbl_test <- tbl_df(test_full)

# combine training and testing data
tbl_train_test <- bind_rows(tbl_train, tbl_test)

# Create a subset of data with only mean and standard deviation observations
#tbl_train_test <- select(tbl_train_test, one_of(features_mean_std))

# sample of how we want the data transformed for just 1 observation to get narrow form of data

tbl_1 <- select(tbl_train_test,51, 1,2,4)
tbl_template <- mutate(tbl_1, feature = names(tbl_1)[4])
names(tbl_template)[4] <- "obs"

# create empty table to hold transformed data
tbl_transform <- filter(tbl_template, activity_id == 100)

# for loop to transpose the columns as rows
for (x in 3: length(names(tbl_train))-1) {
  
  tbl_1 <- select(tbl_train_test,51, 1,2,x)
  tbl_2 <- mutate(tbl_1, feature = names(tbl_1)[4])
  names(tbl_2)[4] <- "obs"
  tbl_transform <- bind_rows(tbl_transform, tbl_2)
} 
# Not sure why 7352 NA values have been inserted into table, the following line is to eliminate the NAs
tbl_transform <- filter(tbl_transform, is.na(feature)==FALSE)

#join with activity vector to get activity name
tbl_transform_act_name <- merge(tbl_transform,activity)

#Re-order columns in so all dimensions are listed first with the measure as the final attribute
tbl_final <- select(tbl_transform_act_name,train_test,subject_id,activity_name,feature,obs)

#4. Appropriately labels the data set with descriptive variable names.
# Create Variable data frame with variable/feature id and descriptive variable name
variable_id <- c("fBodyAcc-mean()-X",
                 "fBodyAcc-mean()-Y",
                 "fBodyAcc-mean()-Z",
                 "fBodyAcc-std()-X",
                 "fBodyAcc-std()-Y",
                 "fBodyAcc-std()-Z",
                 "fBodyAccJerk-mean()-X",
                 "fBodyAccJerk-mean()-Y",
                 "fBodyAccJerk-mean()-Z",
                 "fBodyAccJerk-std()-X",
                 "fBodyAccJerk-std()-Y",
                 "fBodyAccJerk-std()-Z",
                 "fBodyGyro-mean()-X",
                 "fBodyGyro-mean()-Y",
                 "fBodyGyro-mean()-Z",
                 "fBodyGyro-std()-X",
                 "fBodyGyro-std()-Y",
                 "fBodyGyro-std()-Z",
                 "tBodyAcc-mean()-X",
                 "tBodyAcc-mean()-Y",
                 "tBodyAcc-mean()-Z",
                 "tBodyAcc-std()-X",
                 "tBodyAcc-std()-Y",
                 "tBodyAcc-std()-Z",
                 "tBodyAccJerk-mean()-X",
                 "tBodyAccJerk-mean()-Y",
                 "tBodyAccJerk-mean()-Z",
                 "tBodyAccJerk-std()-X",
                 "tBodyAccJerk-std()-Y",
                 "tBodyAccJerk-std()-Z",
                 "tBodyGyro-mean()-X",
                 "tBodyGyro-mean()-Y",
                 "tBodyGyro-mean()-Z",
                 "tBodyGyro-std()-X",
                 "tBodyGyro-std()-Y",
                 "tBodyGyro-std()-Z",
                 "tBodyGyroJerk-mean()-X",
                 "tBodyGyroJerk-mean()-Y",
                 "tBodyGyroJerk-mean()-Z",
                 "tBodyGyroJerk-std()-X",
                 "tBodyGyroJerk-std()-Y",
                 "tBodyGyroJerk-std()-Z",
                 "tGravityAcc-mean()-X",
                 "tGravityAcc-mean()-Y",
                 "tGravityAcc-mean()-Z",
                 "tGravityAcc-std()-X",
                 "tGravityAcc-std()-Y",
                 "tGravityAcc-std()-Z"
)

variable_desc <- c("Mean of Frequency Domain for Body Acceleration on the X axis",
                   "Mean of Frequency Domain for Body Acceleration on the Y axis",
                   "Mean of Frequency Domain for Body Acceleration on the Z axis",
                   "Standard Deviation of Frequency Domain for Body Acceleration on the X axis",
                   "Standard Deviation of Frequency Domain for Body Acceleration on the Y axis",
                   "Standard Deviation of Frequency Domain for Body Acceleration on the Z axis",
                   "Mean of Frequency Domain for Jerk of Body Acceleration on the X axis",
                   "Mean of Frequency Domain for Jerk of Body Acceleration on the Y axis",
                   "Mean of Frequency Domain for Jerk of Body Acceleration on the Z axis",
                   "Standard Deviation of Frequency Domain for Jerk of Body Acceleration on the X axis",
                   "Standard Deviation of Frequency Domain for Jerk of Body Acceleration on the Y axis",
                   "Standard Deviation of Frequency Domain for Jerk of Body Acceleration on the Z axis",
                   "Mean of Frequency Domain for Angular velocity of the body on the X axis",
                   "Mean of Frequency Domain for Angular velocity of the body on the Y axis",
                   "Mean of Frequency Domain for Angular velocity of the body on the Z axis",
                   "Standard Deviation of Frequency Domain for Angular velocity of the body on the X axis",
                   "Standard Deviation of Frequency Domain for Angular velocity of the body on the Y axis",
                   "Standard Deviation of Frequency Domain for Angular velocity of the body on the Z axis",
                   "Mean of Time Domain for Body Accelerationon the X axis",
                   "Mean of Time Domain for Body Accelerationon the Y axis",
                   "Mean of Time Domain for Body Accelerationon the Z axis",
                   "Standard Deviation of Time Domain for Body Acceleration on the X axis",
                   "Standard Deviation of Time Domain for Body Acceleration on the Y axis",
                   "Standard Deviation of Time Domain for Body Acceleration on the Z axis",
                   "Mean of Time Domain for Jerk of Body Acceleration on the X axis",
                   "Mean of Time Domain for Jerk of Body Acceleration on the Y axis",
                   "Mean of Time Domain for Jerk of Body Acceleration on the Z axis",
                   "Standard Deviation of Time Domain for Jerk of Body Acceleration on the X axis",
                   "Standard Deviation of Time Domain for Jerk of Body Acceleration on the Y axis",
                   "Standard Deviation of Time Domain for Jerk of Body Acceleration on the Z axis",
                   "Mean of Time Domain for Angular velocity of the body on the X axis",
                   "Mean of Time Domain for Angular velocity of the body on the Y axis",
                   "Mean of Time Domain for Angular velocity of the body on the Z axis",
                   "Standard Deviation of Time Domain for Angular velocity of the body on the X axis",
                   "Standard Deviation of Time Domain for Angular velocity of the body on the Y axis",
                   "Standard Deviation of Time Domain for Angular velocity of the body on the Z axis",
                   "Mean of Time Domain for Jerk of Angular velocity of the body on the X axis",
                   "Mean of Time Domain for Jerk of Angular velocity of the body on the Y axis",
                   "Mean of Time Domain for Jerk of Angular velocity of the body on the Z axis",
                   "Standard Deviation of Time Domain for Jerk of Angular velocity of the body on the X axis",
                   "Standard Deviation of Time Domain for Jerk of Angular velocity of the body on the Y axis",
                   "Standard Deviation of Time Domain for Jerk of Angular velocity of the body on the Z axis",
                   "Mean of Time domain for Gravity Acceleration on the X axis",
                   "Mean of Time domain for Gravity Acceleration on the Y axis",
                   "Mean of Time domain for Gravity Acceleration on the Z axis",
                   "Standard Deviation of Time domain for Gravity Acceleration on the X axis",
                   "Standard Deviation of Time domain for Gravity Acceleration on the Y axis",
                   "Standard Deviation of Time domain for Gravity Acceleration on the Z axis"
)

variable_df <- data.frame(variable_id,variable_desc)

#Join with fact table to use descriptive variable names
tbl_final_desc <- merge(tbl_final,variable_df, by.x = "feature", by.y = "variable_id")

#select only required columns
tbl_final_2 <- select(tbl_final_desc,train_test,subject_id,activity_name,variable_desc,obs)


#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tbl_final_group <- summarise(group_by(tbl_final_desc,subject_id,activity_name,variable_desc),avg_value = mean(obs))

#write data table to txt file
write.table(tbl_final_group,"TidyData.txt",row.names =FALSE)
