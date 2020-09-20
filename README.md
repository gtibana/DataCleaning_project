This is the proceedure to obtain, filter, select and merge data

## 1. Load the library

## 2. Set work directory

## 3. Download the data

## 4. Verify an decompress file

## 5. Read files
# a. Read features file and asign to features

# b. make variables tidy
- Delete duplicated data ("BodyBody")
- Make lower
- Delete "-"
- Delete "("
- Delete ")"
- Filter by mean() or std()

# c. Read activity labels file and asign to activitylabels

# d. make activities tidy
- Make lower
- Delete "_"

# e. Read test data file and asign to testvalues

# f. Read test activities file and asign to testactivities

# g. Read test subjects file and asign to testsubjects

# h. Merges test activities with labels

# i. Combining test values, activities, subjects

# j. Read train data file and asign to trainvalues

# k. Read train activities file and asign to trainactivities

# l. Read train subjects file ans asign to trainsubjects

# m. Merges train activities with labels

# n. Combining train values, activities, subjects

## 6. Merge test data and train data

# a. Write data file to reuse

## 7. Group by activity and subject

# a. calculate Average

# a. Write a average file to reuse
