### Merge the test ans training datasets

## 1. Load the librart
library(dplyr)

## 2. work directory
if(!dir.exists("./data")) dir.create("./data")
setwd("./data/")

## 3. Download the data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile <- "UCI HAR Dataset.zip"
download.file(fileUrl, destFile)

## 4. Verify an decompress file
if(file.exists(destFile))
        unzip(destFile)

## 5. Read files

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("rownumber", "variablename"))
# a. make variables tidy
features <- mutate(features, variablename = gsub("BodyBody", "Body", variablename))
features <- mutate(features, variablename = tolower(variablename))
features <- mutate(features, variablename = gsub("-", "", variablename))
features <- mutate(features, variablename = gsub("\\(", "", variablename))
features <- mutate(features, variablename = gsub("\\)", "", variablename))
features <- mutate(features, variablename = gsub(",", "", variablename))

activitieslabels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activity", "description"))
# b. make activities tidy
activitieslabels <- mutate(activitieslabels, description = gsub("_", "", description))
activitieslabels <- mutate(activitieslabels,description = tolower(description))

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#Merges the data
#x_test
testData <- rbind(x_train, x_test)
#y_test
trainData <- rbind(y_train, y_test)
#subject
Subject <- rbind(subject_train, subject_test)
#merge
mergetesttrain <- cbind(Subject, trainData, testData)

#filter by the mean and standard deviation
filtermergetesttrain <- mergetesttrain %>% select(subject, code, contains("mean"), contains("std"))

#Name the activities
filtermergetesttrain$code <- activitieslabels[filtermergetesttrain$code, 2]

#Average of each variable for each activity and each subject
data <- filtermergetesttrain %>% group_by(subject, filtermergetesttrain$code) %>% summarise_all(funs(mean))
write.table(data, "Average_by_activityandsubject.txt", row.name=FALSE)
