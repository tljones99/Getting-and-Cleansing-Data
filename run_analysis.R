## Download the data 

## Set working director for the files
setwd("C:/Users/tljon/datasciencecoursera")

## Create file location
if(!file.exists("./data")) {dir.create("./data")}

## Connect to file location on the internet
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              destfile ="./data/Dataset.zip", method = "curl")

## Unzip the downloaded Dataset.zip to the ./data directory
unzip(zipfile = "./data/Dataset.zip", exdir = "./data")

## Now checking to ensure Dataset.zip has been unzipped and files in folder
list.files("./data")


## Set path for new folder
pathdata = file.path("./data", "UCI HAR Dataset")
files = list.files(pathdata, recursive = TRUE)
##  View the files in the list
files
## [1] "activity_labels.txt"                          "features.txt"                                
## [3] "features_info.txt"                            "README.txt"                                  
## [5] "test/Inertial Signals/body_acc_x_test.txt"    "test/Inertial Signals/body_acc_y_test.txt"   
## [7] "test/Inertial Signals/body_acc_z_test.txt"    "test/Inertial Signals/body_gyro_x_test.txt"  
## [9] "test/Inertial Signals/body_gyro_y_test.txt"   "test/Inertial Signals/body_gyro_z_test.txt"  
## [11] "test/Inertial Signals/total_acc_x_test.txt"   "test/Inertial Signals/total_acc_y_test.txt"  
## [13] "test/Inertial Signals/total_acc_z_test.txt"   "test/subject_test.txt"                       
## [15] "test/X_test.txt"                              "test/y_test.txt"                             
## [17] "train/Inertial Signals/body_acc_x_train.txt"  "train/Inertial Signals/body_acc_y_train.txt" 
## [19] "train/Inertial Signals/body_acc_z_train.txt"  "train/Inertial Signals/body_gyro_x_train.txt"
## [21] "train/Inertial Signals/body_gyro_y_train.txt" "train/Inertial Signals/body_gyro_z_train.txt"
## [23] "train/Inertial Signals/total_acc_x_train.txt" "train/Inertial Signals/total_acc_y_train.txt"
## [25] "train/Inertial Signals/total_acc_z_train.txt" "train/subject_train.txt"                     
## [27] "train/X_train.txt"                            "train/y_train.txt"  
## In total, 28 files have been extracted and are ready to be analyzed

## Create the test and training data set.
##       A.  Create the test data set
##       B.  Create the training data set
##       C.  Create the features data set
##       D.  Create the activity labels data set

## Load packages to support analysis
library(dplyr)
library(data.table)
library(tidyr)

## Read the test data set
xtest = read.table(file.path(pathdata, "test", "X_test.txt"), header = FALSE)
ytest = read.table(file.path(pathdata, "test", "y_test.txt"), header = FALSE)
subject_test = read.table(file.path(pathdata, "test", "subject_test.txt"), header = FALSE)


## Reading the training data set     
xtrain = read.table(file.path(pathdata, "train", "X_train.txt"), header = FALSE)
ytrain = read.table(file.path(pathdata, "train", "y_train.txt"), header = FALSE)
subject_train = read.table(file.path(pathdata, "train", "subject_train.txt"), header = FALSE)

## Read the features data set
features = read.table(file.path(pathdata, "features.txt"), header = FALSE)

## Read the activity labels data set
activityLabels = read.table(file.path(pathdata, "activity_labels.txt"), header = FALSE)


## Uses descriptive activity names to name the activities in the data set
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"
colnames(activityLabels) <- c('activityId', 'activityType')

## Data sets have been created and columns have been named.

## Time to merge the test and train data sets
mergeTest = cbind(ytest, subject_test, xtest)
mergeTrain = cbind(ytrain, subject_train, xtrain)

## Create the data table that merges both data sets
MergedSet = rbind(mergeTest, mergeTest)
## This step completes the merger of the data sets

## Read the values from the new MergedSet and get a subset of all means and standard deviations
colNames = colnames(MergedSet)
MeanAndSD = (grepl("activityId", colNames) | grepl("subjectId", colNames) | 
  grepl("mean..", colNames) | grepl("std..", colNames))

## Pull the required data set
setMeanAndSD <- MergedSet[, MeanAndSD == TRUE]

## Name the activities in the data set using descriptive names
setActivityNames = merge(setMeanAndSD, activityLabels, by = 'activityId', all.x = TRUE)

## The outcomes and solutions are MergedSet and setMeanAndSD

## Create a new tidy set
newTidySet <- aggregate(. ~subjectId + activityId, setActivityNames, mean)
newTidySet <- newTidySet[order(newTidySet$subjectId, newTidySet$activityId), ]

## Write the output to a new saved text file
write.table(newTidySet, "newTidySet.txt", row.name = FALSE)





