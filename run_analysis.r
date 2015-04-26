# Download and Extract the original data
zipURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(zipURL, destfile = "UCI HAR Dataset.zip", mode="wb")
dataXtest <- read.table(unzip("UCI HAR Dataset.zip", "UCI HAR Dataset/test/X_test.txt"))
dataYtest <- read.table(unzip("UCI HAR Dataset.zip", "UCI HAR Dataset/test/y_test.txt"))
dataStest <- read.table(unzip("UCI HAR Dataset.zip", "UCI HAR Dataset/test/subject_test.txt"))
dataXtrain <- read.table(unzip("UCI HAR Dataset.zip", "UCI HAR Dataset/train/X_train.txt"))
dataYtrain <- read.table(unzip("UCI HAR Dataset.zip", "UCI HAR Dataset/train/y_train.txt"))
dataStrain <- read.table(unzip("UCI HAR Dataset.zip", "UCI HAR Dataset/train/subject_train.txt"))
actiLabels <- read.table(unzip("UCI HAR Dataset.zip", "UCI HAR Dataset/activity_labels.txt"))
featLabels <- read.table(unzip("UCI HAR Dataset.zip", "UCI HAR Dataset/features.txt"))

# Apply original variable names to dataframe
colnames(dataXtest) <- featLabels$V2
colnames(dataXtrain) <- featLabels$V2

# Apply descriptive activity names to activity data
library(plyr)
actiTest <- join(dataYtest, actiLabels)
actiTrain <- join(dataYtrain, actiLabels)


# Combine activity and subject data with dataframe and apply descriptive column names
dataTest <- cbind(dataStest, actiTest$V2, dataXtest)
colnames(dataTest)[1] <- "subject"
colnames(dataTest)[2] <- "activity"
dataTrain <- cbind(dataStrain, actiTrain$V2, dataXtrain)
colnames(dataTrain)[1] <- "subject"
colnames(dataTrain)[2] <- "activity"

# Combine test and train data into single dataframe of all subjects
## This should fulfill criteria 1 in the assignment
dataFull <- rbind(dataTest, dataTrain)

# Subset the variables that are means and standard deviations and create a dataframe of just those variables
## This should fulfill criteria 2 in the assignment
vars <- names(dataFull)
varsSub <- grep("mean|std", vars)
dataSub <- dataFull[,varsSub]

# Bind back in the activity names to the subsetted dataframe
## This should fulfill critera 3 in the assignment
dataSub <- cbind(dataFull$subject, dataFull$activity, dataSub)
colnames(dataSub)[1] <- "subject"
colnames(dataSub)[2] <- "activity"

# Apply descriptive variable names to dataframe
## This should fulfill critera 4 in the assignment
names(dataSub) <- gsub("mean\\(\\)", "Mean", names(dataSub))
names(dataSub) <- gsub("std\\(\\)", "StandardDeviation", names(dataSub))
names(dataSub) <- gsub("mad\\(\\)", "MedianAbsoluteDeviation", names(dataSub))
names(dataSub) <- gsub("max\\(\\)", "MaximumValue", names(dataSub))
names(dataSub) <- gsub("min\\(\\)", "MinimumValue", names(dataSub))
names(dataSub) <- gsub("sma\\(\\)", "SignalMagnitudeArea", names(dataSub))
names(dataSub) <- gsub("energy\\(\\)", "EnergyMeasure", names(dataSub))
names(dataSub) <- gsub("iqr\\(\\)", "InterquartileRange", names(dataSub))
names(dataSub) <- gsub("entropy\\(\\)", "SignalEntropy", names(dataSub))
names(dataSub) <- gsub("arCoeff\\(\\)", "AutorregresionCoefficients", names(dataSub))
names(dataSub) <- gsub("correlation\\(\\)", "Correlation", names(dataSub))
names(dataSub) <- gsub("maxInds", "MaximumFrequencyMagnitudeIndex", names(dataSub))
names(dataSub) <- gsub("meanFreq\\(\\)", "MeanFrequency", names(dataSub))
names(dataSub) <- gsub("skewness\\(\\)", "DomainSignalSkewness", names(dataSub))
names(dataSub) <- gsub("kurtosis\\(\\)", "DomainSignalKurtosis", names(dataSub))
names(dataSub) <- gsub("bandsEnergy\\(\\)", "FrequencyIntervalEnergy", names(dataSub))
names(dataSub) <- gsub("angle", "Angle", names(dataSub))
names(dataSub) <- gsub("Gyro","Gyroscope", names(dataSub))
names(dataSub) <- gsub("Acc","Accelerometer", names(dataSub))
names(dataSub) <- gsub("Mag","Magnitude", names(dataSub))
names(dataSub) <- gsub("-","", names(dataSub))

# Melt the data to cast it, and we now have wide-form tidy data
## This should fulfill criteria 5 of the assignment, but we'll convert it to narrow tidy data to make it more compact
library(reshape2)
dataMelt <- melt(dataSub, id=names(dataSub[,1:2]), measure.vars=names(dataSub[,3:ncol(dataSub)]))
colnames(dataMelt)[3] <- "metric"
colnames(dataMelt)[4] <- "metricValue"
castData <- dcast(dataMelt, subject+activity~metric, mean)

# Or re-melt it for narrow-form tidy data
tidyMelt <- melt(castData, id=names(castData[,1:2]), measure.vars=names(castData[,3:ncol(castData)]))
colnames(tidyMelt)[3] <- "metric"
colnames(tidyMelt)[4] <- "metricValue"

# Order the tidied data to make it look nicer
library(dplyr)
tidyMelt <- arrange(tidyMelt, subject, activity)

# Export the tidy data for use
write.table(tidyMelt, file="samsungDataTidy.txt", sep = " ", row.names=FALSE)