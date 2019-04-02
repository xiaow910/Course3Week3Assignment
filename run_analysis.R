library(dplyr)
# Load activity labels + features
activityLabels <- read.table("//cdc.gov/private/L137/yks5/Data Science/Course 3-Getting and Cleaning Data/week3/assignments/UCI HAR Dataset/activity_labels.txt")
features <- read.table("//cdc.gov/private/L137/yks5/Data Science/Course 3-Getting and Cleaning Data/week3/assignments/UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation
# Appropriately labels the data set with descriptive variable names.
measurement<- grep(".*mean.*|.*std.*", features[,2])
measurement.names <- features[measurement,2]
measurement.names <- gsub('-mean', 'Mean', measurement.names)
measurement.names <- gsub('-std', 'Std', measurement.names)
measurement.names <- gsub('^f', 'frequencyDomain', measurement.names)
measurement.names <- gsub('^t', 'timeDomain', measurement.names)
measurement.names <- gsub('Acc', 'Accelerometer', measurement.names)
measurement.names <- gsub('Gyro', 'Gyroscope', measurement.names)
measurement.names <- gsub('Mag', 'Magnitude', measurement.names)
measurement.names <- gsub('Freq', 'Frequency', measurement.names)
measurement.names <- gsub('[\\(\\)-]', '', measurement.names)

# Merges the training and the test sets to create one data set.
test1<-read.table("//cdc.gov/private/L137/yks5/Data Science/Course 3-Getting and Cleaning Data/week3/assignments/UCI HAR Dataset/test/subject_test.txt",col.names = "subject")
test2<-read.table("//cdc.gov/private/L137/yks5/Data Science/Course 3-Getting and Cleaning Data/week3/assignments/UCI HAR Dataset/test/X_test.txt")
test3<-read.table("//cdc.gov/private/L137/yks5/Data Science/Course 3-Getting and Cleaning Data/week3/assignments/UCI HAR Dataset/test/y_test.txt",col.names = "code")
test<-cbind(test1,test2[measurement],test3)

train1<-read.table("//cdc.gov/private/L137/yks5/Data Science/Course 3-Getting and Cleaning Data/week3/assignments/UCI HAR Dataset/train/subject_train.txt",col.names = "subject")
train2<-read.table("//cdc.gov/private/L137/yks5/Data Science/Course 3-Getting and Cleaning Data/week3/assignments/UCI HAR Dataset/train/X_train.txt")
train3<-read.table("//cdc.gov/private/L137/yks5/Data Science/Course 3-Getting and Cleaning Data/week3/assignments/UCI HAR Dataset/train/y_train.txt",col.names = "code")
train<-cbind(train1,train2[measurement],train3)

alldata<-rbind(test,train)

colnames(alldata) <- c("subject",measurement.names,"code")
head(alldata)

# Uses descriptive activity names to name the activities in the data set.
alldata$code <- activityLabels[alldata$code,2]

# From the data set in step 4, creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject.

Means <- alldata %>% 
  group_by(subject, code) %>%
  summarise_each(funs(mean))

write.table(Means, "//cdc.gov/private/L137/yks5/Data Science/Course 3-Getting and Cleaning Data/week3/assignments/UCI HAR Dataset/final.txt", row.names = FALSE, quote = FALSE)
















