---
title: "README"
author: "Bing"
date: "31 May 2018"
output: html_document
---

One of the most exciting areas in all of data science right now is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.  
- Triaxial Angular velocity from the gyroscope.   
- A 561-feature vector with time and frequency domain variables.   
- Its activity label.   
- An identifier of the subject who carried out the experiment.  



The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ  
tGravityAcc-XYZ  
tBodyAccJerk-XYZ  
tBodyGyro-XYZ  
tBodyGyroJerk-XYZ  
tBodyAccMag  
tGravityAccMag  
tBodyAccJerkMag  
tBodyGyroMag  
tBodyGyroJerkMag  
fBodyAcc-XYZ  
fBodyAccJerk-XYZ  
fBodyGyro-XYZ  
fBodyAccMag  
fBodyAccJerkMag  
fBodyGyroMag  
fBodyGyroJerkMag  




The project will create one R script called run_analysis.R that does the following:

1. Merges the training and the test sets to create one data set.  
2. Extracts only the measurements on the mean and standard deviation for each measurement.   
3. Uses descriptive activity names to name the activities in the data set.  
4. Appropriately labels the data set with descriptive variable names.   
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  


##Download the data if it has not been done before
First set the working directory:
setwd("C:/...")
```{r}
if(!file.exists("./data/UCI HAR Dataset")){
    temp <- tempfile()
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, temp)
    unz(temp, "./data/UCI HAR Dataset")
    unlink(temp)
} 
```

##Merge the training and the test sets to create one data set
Read the training and test datasets and bind them together

```{r}
train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
activity <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train,activity)
train <- cbind(train,subject)

test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
activity <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test,activity)
test <- cbind(test,subject)

data <- rbind(train,test)
```

##Appropriately label the data set with descriptive variable names 
Label the variables with their titles in the features file

```{r}
features <- read.table("./data/UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])
features <- rbind(features, c(562,"activity"))
features <- rbind(features, c(563,"subject"))

colnames(data) <- features$V2
```

##Extract the measurements on the mean and standard deviation for each measurement
Search for mean and std in the titles to select the variables
```{r}
datameans <- data[,grepl("mean",names(data))]
datastd <- data[,grepl("std",names(data))]
data_new <- cbind(datameans,datastd)

activity <- data$activity
subject <- data$subject
data_new <- cbind(data_new,activity)
data_new <- cbind(data_new,subject)
```

##Use descriptive activity names to name the activities in the data set
Label the acxtivities with the activity labels by making it a factor variable
```{r}
act_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
data_new$activity <- factor(data_new$activity,
                            levels = act_labels$V1,
                            labels = act_labels$V2)
```

##Create a second, independent tidy data set with the average of each 
##variable for each activity and each subject
Take the mean of the variables, separating by activity and person

```{r}
data_tidy <- aggregate(data_new, by = list(activity, subject), FUN = mean)

data_tidy <- data_tidy[,1:81]
data_tidy <- rename(data_tidy, activity=Group.1, subject=Group.2)
data_tidy$activity <- factor(data_tidy$activity,
                             levels = act_labels$V1,
                             labels = act_labels$V2)
```

Write the tidy data results
```{r}
write.table(data_tidy, file="data_tidy.txt", row.name=FALSE)
```
            
            