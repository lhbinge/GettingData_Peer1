#Set working directory

setwd("C:/Users/Laurie/OneDrive/Documents/BING/METRICS/R Coursera")

#Download the data

if(!file.exists("./data/UCI HAR Dataset")){
    temp <- tempfile()
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, temp)
    unz(temp, "./data/UCI HAR Dataset")
    unlink(temp)
} 

#Merge the training and the test sets to create one data set

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

#Appropriately label the data set with descriptive variable names 

features <- read.table("./data/UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])
features <- rbind(features, c(562,"activity"))
features <- rbind(features, c(563,"subject"))

colnames(data) <- features$V2

#Extract the measurements on the mean and standard deviation for each measurement

datameans <- data[,grepl("mean",names(data))]
datastd <- data[,grepl("std",names(data))]
data_new <- cbind(datameans,datastd)

activity <- data$activity
subject <- data$subject
data_new <- cbind(data_new,activity)
data_new <- cbind(data_new,subject)

#Use descriptive activity names to name the activities in the data set

act_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
data_new$activity <- factor(data_new$activity,
                            levels = act_labels$V1,
                            labels = act_labels$V2)

#Create a second, independent tidy data set with the average of each 
#variable for each activity and each subject

data_tidy <- aggregate(data_new, by = list(activity, subject), FUN = mean)

data_tidy <- data_tidy[,1:81]
data_tidy <- rename(data_tidy, activity=Group.1, subject=Group.2)
data_tidy$activity <- factor(data_tidy$activity,
                             levels = act_labels$V1,
                             labels = act_labels$V2)

write.table(data_tidy, file="data_tidy.txt", row.name=FALSE)

            
            