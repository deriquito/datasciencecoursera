# Course Project for: Getting and Cleaning Data, John Hopkins University, Coursera
# Author: A. Deriquito
# Date Completed: 07/22/2015
# This script:
# 1. Downloads the Human Activity Recognition Dataset from http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 2. Merges the training and the test sets to create one data set.
# 3. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 4. Uses descriptive activity names to name the activities in the data set.
# 5. Appropriately labels the data set with descriptive variable names. 
# 6. Creates a second, independent tidy data set with the average of each variable for each activity and each subject and writes it in a text file.

# Instruction to the user of this script: 
# 1. Copy this file to your working directory
# 2. In R editor, set your working directory using the following command: setwd(...)
# 3. Run this script using the following command: source("run_analysis.R")

#----------------------------------------------------------------------------------------------------------------------------------------------
# Download the zip file and unzip it to a folder called myData
#----------------------------------------------------------------------------------------------------------------------------------------------
if(!file.exists("./myData")) dir.create("./myData")
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Dataset.zip")
unzip(zipfile="./Dataset.zip",exdir="./myData")

#----------------------------------------------------------------------------------------------------------------------------------------------
# Go to the directory UCI HAR Dataset where the raw flat files are
#----------------------------------------------------------------------------------------------------------------------------------------------
setwd("./myData/UCI HAR Dataset")

#----------------------------------------------------------------------------------------------------------------------------------------------
# Load the features dataset to a table called features.
#----------------------------------------------------------------------------------------------------------------------------------------------
features <- read.table("features.txt")

#----------------------------------------------------------------------------------------------------------------------------------------------
# Load the activity labels to a table called activity labels.
#----------------------------------------------------------------------------------------------------------------------------------------------
activityLabels <- read.table("activity_labels.txt")

#----------------------------------------------------------------------------------------------------------------------------------------------
# Load the training datasets to the following tables:
#
# 1. trainingMeasurements - the values of the different variables per person per activity 
# 2. trainingSubjects - the numeric codes of the persons who participated in the training which correspond to the rows in trainingMeasurements
# 3. trainingActivities - the activity names that correspond to the rows in trainingMeasurements
#----------------------------------------------------------------------------------------------------------------------------------------------
trainingMeasurements <- read.table("train/x_train.txt")
colnames(trainingMeasurements) <- features$V2 # change the variable names to make them more descriptive
trainingSubjects <- read.table("train/subject_train.txt", col.names=c("Subject"))
trainingActivities <- data.frame(activityLabels[read.table("train/y_train.txt")$V1,]$V2)
colnames(trainingActivities) <- c("Activity")  # change the variable name to make it more descriptive

#----------------------------------------------------------------------------------------------------------------------------------------------
# Load the test datasets to the following tables:
#
# 1. testMeasurements - the values of the different variables per person per activity
# 2. testSubjects - the numeric codes of the persons who participated in the test that correspond to the rows in testMeasurements
# 3. testActivities - the activity names that correspond to the rows in testMeasurements
#----------------------------------------------------------------------------------------------------------------------------------------------
testMeasurements <- read.table("test/x_test.txt")
colnames(testMeasurements) <- features$V2  # change the variable names to make them more descriptive
testSubjects <- read.table("test/subject_test.txt", col.names=c("Subject"))
testActivities <- data.frame(activityLabels[read.table("test/y_test.txt")$V1,]$V2)
colnames(testActivities) <- c("Activity") # change the column name to make it more descriptive

#----------------------------------------------------------------------------------------------------------------------------------------------
# Create a table called trainingMeanAndStd that contains the data from table trainingMeasurements for the mean and std variables only.
#----------------------------------------------------------------------------------------------------------------------------------------------
trainingMeanAndStd <- trainingMeasurements[,grep("mean\\(\\)|std\\(\\)", names(trainingMeasurements), value=TRUE)]

#----------------------------------------------------------------------------------------------------------------------------------------------
# Create a table called testMeanAndStd that contains the data from table testMeasurements for the mean and std variables only.
#----------------------------------------------------------------------------------------------------------------------------------------------
testMeanAndStd <- testMeasurements[,grep("mean\\(\\)|std\\(\\)", names(testMeasurements), value=TRUE)]

#----------------------------------------------------------------------------------------------------------------------------------------------
# Merge the three training tables into one table called trainingData.
#----------------------------------------------------------------------------------------------------------------------------------------------
trainingData <- cbind(trainingActivities, trainingSubjects, trainingMeanAndStd)

#----------------------------------------------------------------------------------------------------------------------------------------------
# Merge the three test tables into one table called testData.
#----------------------------------------------------------------------------------------------------------------------------------------------
testData <- cbind(testActivities, testSubjects, testMeanAndStd)

#----------------------------------------------------------------------------------------------------------------------------------------------
# Merge training and test data into one table called combinedData.  This is now the table required in the Course Project Step 4.
#----------------------------------------------------------------------------------------------------------------------------------------------
combinedData <- rbind(trainingData, testData)

#----------------------------------------------------------------------------------------------------------------------------------------------
# Create a dataset that has the averages of the measures in combinedData by Subject and Activity and write it to a text file called tidydata,txt.
#----------------------------------------------------------------------------------------------------------------------------------------------
meanAndStdAverages <- aggregate(. ~Subject + Activity, combinedData, mean)
write.table(meanAndStdAverages[order(meanAndStdAverages$Subject, meanAndStdAverages$Activity),], file = "tidydata.txt",row.name=FALSE)

