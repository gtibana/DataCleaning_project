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
# a. Read features
featuresFile <- paste("UCI HAR Dataset","features.txt", sep = "/")
features <- read.table(featuresFile, col.names = c("rownumber", "variablename"))

# b. make variables tidy
fvariables <- mutate(features, variablename = gsub("BodyBody", "Body", variablename))
fvariables <- mutate(fvariables, variablename = tolower(variablename))
fvariables <- mutate(fvariables, variablename = gsub("-", "", variablename))
fvariables <- mutate(fvariables, variablename = gsub("\\(", "", variablename))
fvariables <- mutate(fvariables, variablename = gsub("\\)", "", variablename))
fvariables <- mutate(fvariables, variablename = gsub(",", "", variablename))

filtervariables <- filter(fvariables, grepl("mean\\(\\)|std\\(\\)", variablename))

# c. Read activity labels
activitylabelsFile <- paste("UCI HAR Dataset","activity_labels.txt", sep = "/")
activitylabels <- read.table(activitylabelsFile, col.names = c("activity", "description"))

# d. make activities tidy

avariables <- mutate(activitylabels, description = gsub("_", "", description))
avariables <- mutate(avariables,description = tolower(description))


# e. Read test data
testvaluesFile <- paste("UCI HAR Dataset","test/X_test.txt", sep = "/")
testvalues <- read.table(testvaluesFile, col.names = fvariables$variable)
testfiltervalues <- testvalues[ ,filtervariables$variablename]

# f. Read test activities
testactivitiesFile <- paste("UCI HAR Dataset","test/y_test.txt", sep = "/")
testactivities <- read.table(testactivitiesFile, col.names = c("activity"))

# g. Read test subjects
testsubjectsFile <- paste("UCI HAR Dataset","test/subject_test.txt", sep = "/")
testsubjects <- read.table(testsubjectsFile, col.names = c("suject"))

# h. Merges test activities with labels
mergetestactivities <- merge(testactivities, avariables)

# i. Combining test values, activities, subjects
testdata <- cbind(mergetestactivities, testsubjects, testfiltervalues)

# j. Read train data
trainvaluesFile <- paste("UCI HAR Dataset","train/X_train.txt", sep = "/")
trainvalues <- read.table(trainvaluesFile, col.names = fvariables$variable)
trainfiltervalues <- trainvalues[ ,filtervariables$variablename]

# k. Read train activities
trainactivitiesFile <- paste("UCI HAR Dataset","train/y_train.txt", sep = "/")
trainactivities <- read.table(trainactivitiesFile, col.names = c("activity"))

# l. Read train subjects
trainsubjectsFile <- paste("UCI HAR Dataset","train/subject_train.txt", sep = "/")
trainsubjects <- read.table(trainsubjectsFile, col.names = c("suject"))

# m. Merges train activities with labels
mergetrainactivities <- merge(trainactivities, avariables)

# n. Combining train values, activities, subjects
traindata <- cbind(mergetrainactivities, trainsubjects, trainfiltervalues)

## 6. Merge test data and train data
data <- rbind(testdata, traindata)
data <- mutate(data, subject = as.factor(data$suject))

# a. Write a file to reuse
write.table(data, "ActivitySubject_by_meanAndstddev.txt")

## 7. Group by for average
# a. Group by activity and subject
groupdata <- group_by(data, description, subject)

# b. Average
averagedata <- summarise_each(groupdata, funs(mean))

# a. Write a file to reuse
write.table(averagedata, "Average_by_activityandsubject.txt")
