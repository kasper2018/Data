
# Getting and cleaning Data, week 4 excercise
# Purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.

# Review criteria
# - The submitted data set is tidy.
# - The Github repo contains the required scripts.
# - GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
# - The README that explains the analysis files is clear and understandable.
# - The work submitted for this project is the work of the student who submitted it.

#Dependencies
library(dplyr)
library(data.table)
library(tidyr)

#Set WD
setwd("/Cleaning Data/W4 Excercise/UCI HAR Dataset")

# read data to data.table and assign colnames with col.names
  Features <- read.table("features.txt",header=FALSE) 
  ActivityLabels <- read.table("activity_labels.txt",header=FALSE, col.names = c("Activity.ID","LabelType")) 
  # Subject Files
    subTrain  <- read.table("./train/subject_train.txt", header=FALSE, col.names = "Subject.ID") 
    subTest   <- read.table("./test/subject_test.txt", header=FALSE, col.names = "Subject.ID") 
  # Y-Data (Activity)
    YTrain    <- read.table("./train/y_train.txt", header=FALSE, col.names = "Activity.ID")
    YTest     <- read.table("./test/y_test.txt", header=FALSE, col.names = "Activity.ID")
  # X-Data (Features) //Note: col.names from Features dataset 
    XTrain    <- read.table("./train/x_train.txt", header=FALSE, col.names = Features[,2])
    XTest     <- read.table("./test/x_test.txt", header=FALSE, col.names = Features[,2])

# Merge datasets (rbind = vertical merge)
allSub <- rbind(subTrain, subTest)  #subject
allX <- rbind(XTrain,XTest)         #feature
allY <- rbind(YTrain,YTest)         #activity

# Make one big data.frame
DF <- cbind(allX,allSub,allY)

# Select columns with mean or std (linux GREP)
Select <- grep("*mean*|*std*", names(DF), ignore.case=TRUE)
DF.Select <- DF[,c(562,563,Select)] # col 562 and 563 are Activity and Feature <-- this could be nicer

# Trying to understand what we are doing.... 
str(DF.Select)
head(ActivityLabels)
head(DF.Select$Activity.ID,50)

# match Activity Id from Activitylabels with int. in $Activity.ID, then cleanup 
DF.Select <- merge(ActivityLabels,DF.Select, by = "Activity.ID" ) 
DF.Select$Activity.ID <- NULL

#Final Question: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
DF.Clean <- aggregate(DF.Select[3:ncol(DF.Select)], by = list(DF.Select$LabelType,DF.Select$Subject.ID), FUN = mean )
names(DF.Clean)[1] <- "Activity"
names(DF.Clean)[2] <- "Subject"

write.table(DF.Clean, file = "DFClean.txt", sep=",", row.names=FALSE)



