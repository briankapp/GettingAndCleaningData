library(dplyr)

# A few sanity checks and initializations up front
if (file.exists("features.txt")){
  features <- read.table("features.txt")
  names(features) <- c("index", "Feature Names")
}

if (file.exists("activity_labels.txt")) {
  activities <- read.table("activity_labels.txt")
  names(activities) <- c("Activity number", "Activity")
}

if (file.exists("test/y_test.txt") & file.exists("train/y_train.txt")) {
  activity_label_nums <- rbind(read.table("test/y_test.txt"), read.table("train/y_train.txt"))
  
  #put string labels here instead of just numbers
  activity_labels <- sapply(activity_label_nums[,1], function(index){as.character(activities$Activity[index])})
  activity_labels <- as.data.frame(activity_labels)
  names(activity_labels) <- "Activity"
}

if(file.exists("test/subject_test.txt") & file.exists("train/subject_train.txt")) {
  subject_list <- rbind(read.table("test/subject_test.txt"), read.table("train/subject_train.txt"))
  names(subject_list) <- "Subject ID"
}

if (file.exists("test/X_test.txt") & file.exists("train/X_train.txt")) {
  observations <- rbind(read.table("test/X_test.txt"), read.table("train/X_train.txt"))
  names(observations) <- features$"Feature Names"
}

# put everything together
observations <- cbind(subject_list, activity_labels, observations)

# search for the features that you really want
desiredFeatureIndex <- c(1,2,grep("(mean|std)\\(\\)", names(observations)))

# function to tidy up feature names
cleanupFeatureNames <- function(featureNamesIn) {
  humanReadableFeatures <- sub("^t","TimeDomain", featureNamesIn)
  humanReadableFeatures <- sub("^f","FrequencyDomain", humanReadableFeatures)
  humanReadableFeatures <- sub("Acc","Acceleration", humanReadableFeatures)
  humanReadableFeatures <- sub("Gyro","Gyroscopic", humanReadableFeatures)
  humanReadableFeatures <- sub("Mag","Magnitude", humanReadableFeatures)
  humanReadableFeatures <- sub("mean\\(\\)","Mean", humanReadableFeatures)
  humanReadableFeatures <- sub("std\\(\\)","StandardDeviation", humanReadableFeatures)
  humanReadableFeatures <- gsub(" ","_", humanReadableFeatures)  
  humanReadableFeatures <- sub("\\-([XYZ])$","_\\1_Axis", humanReadableFeatures)    
  humanReadableFeatures <- gsub("\\-","_", humanReadableFeatures)    
  humanReadableFeatures <- gsub("([a-z])([A-Z])","\\1_\\2", humanReadableFeatures)    
}

# clean up feature names
desiredFeatures <- cleanupFeatureNames(names(observations)[desiredFeatureIndex])

# get observations you need and make sure that names are in desired form
desiredObservations <- observations[,desiredFeatureIndex]
names(desiredObservations) <- desiredFeatures

# group data and summarize
groupedData <- group_by(desiredObservations, Subject_ID, Activity)
gdSummary <- summarize_each(groupedData,funs(mean))
write.table(gdSummary,file="tidy.txt",row.names = FALSE)