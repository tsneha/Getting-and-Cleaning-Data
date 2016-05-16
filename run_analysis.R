setwd("C:/Users/sneha/Desktop/Coursera Getting & Cleaning")
#Download the dataset
filename<- "getdata.zip"
if(!file.exists(filename)){
  fURL<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fURL,filename)
}
# unzip
if(!file.exists("UCI HAR Dataset")){
  unzip(filename)
}
#Loading activity labels
activity_Labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_Labels[,2]<-as.character(activity_Labels[,2])
#Loading features and extracting only the required features
features<-read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])
selectedFeatures <- grep(".*mean.*|.*std.*", features[,2])
selectedFeatures.names <- features[selectedFeatures,2]
features[selectedFeatures,2] <- gsub('-mean', 'Mean', features[selectedFeatures,2] )
features[selectedFeatures,2]  <- gsub('-std', 'Std', features[selectedFeatures,2] )
features[selectedFeatures,2]  <- gsub('[-()]', '', features[selectedFeatures,2] )


#Training and test datasets
XTrain <- read.table("UCI HAR Dataset/train/X_train.txt")[selectedFeatures]
activityTrain <- read.table("UCI HAR Dataset/train/Y_train.txt")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
train<- cbind(subjectTrain,activityTrain,XTrain)

XTest <- read.table("UCI HAR Dataset/test/X_test.txt")[selectedFeatures]
activityTest <- read.table("UCI HAR Dataset/test/Y_test.txt")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
test<- cbind(subjectTest,activityTest, XTest)
#Merging the training and the test sets to create one data set
allData<- rbind(train,test)
colnames(allData)<-c("Subject","Activity", features[selectedFeatures,2])
allData$Activity <- factor(allData$Activity, levels = activity_Labels[,1], labels = activity_Labels[,2])
allData$Subject <- factor(allData$Subject)

library(reshape2)
allData_melt <- melt(allData, id = c("Activity", "Subject"))
allData_mean <- dcast(allData_melt, Subject + Activity ~ variable, mean)
write.table(allData_mean, "tidy.txt", row.names = FALSE, quote = FALSE)



