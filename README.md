# "README"


## Introduction
This document will explain the R script *run_analysis*, which you will find in this repository in the file *run_analysis.r*. It will also explain how the original dataset is used by *run_analysis* and the format of the exported tidy data file.

## Repository Contents

The repository contains the following files:

* README.md : A README file explaining the R script for obtaining the SamsungData from the original source, and tidying it inst a more-easily usable format.
* run_analysis.r : The script for downloading and tidying the Samsung data files.
* CodeBook : A code book describing the data.
* SamsungData_Tidy.txt - An example of the tidied data file exported by *run_analysis.r*, in a narrow format.

## *run_analysis.r*

The script *run_analysis.r* combines data from different files in the UCI HAR Dataset into a useable and tidy format allowing for easy further analysis. For more information about the original dataset, see below.

### *run_analysis* Requirements

The script *run_analysis.r* requires two r packages be installed:

* plyr
* reshape2
* dplyr

The packages are used to perform the following functions:

* join()
* melt() 
* dcast() 
* arrange()

The script will load their libraries automatically, but will not attempt to install the packages (to protect the rights of users to determine their own package list).

If you wish to install the packages, you may do so with the following r commands:

* install.packages("plyr")
* install.packages("reshape2")
* install.packages("dplyr")

### *run_analysis* Process

*run_analysis* performs the following steps:

1. Download the UCI HAR Dataset
2. Extract the training and test data, as well as supplemental files featuring feature and activity labels and subject IDs (For a full list of the files extracted, see the section *UCI HAR Dataset Used Filelist* below)
3. Apply feature (variable) labels to the data frames
4. Apply activity names to the observations
5. Combine activity and subject data with dataframe and apply descriptive names for the new variables
6. Combine test and train data into single dataframe of all subjects
 + **[CLASS NOTE: This should fulfill criteria 1 in the assignment]**
7. Subset the variables that are means and standard deviations and create a dataframe of just those variables
 + **[CLASS NOTE: This should fulfill criteria 2 in the assignment]**
8. Bind back in the activity names to the subsetted dataframe
 + **[CLASS NOTE: This should fulfill critera 3 in the assignment]**
9. Apply descriptive variable names to dataframe
 + I set the analysis to change all variable shorthand to long-form, in case of future additions to the data.
 + **[CLASS NOTE: This should fulfill critera 4 in the assignment]**
10. Melt the data to recast it, and we now have wide-form tidy data
 + Though not necessary, the script then takes the additional step of remelting the data into a tidier-looking narrow dataset
11. Export the tidy data for future use
 + **[CLASS NOTE: This should fulfill criteria 5 of the assignment]**

### Using *run_analysis*

To use the *run_analysis* script from your working directory, try the following commands:

* From R console: 

1. *source("run_analysis.r")*
2. *r -f run_analysis.r*

* From R Studio

1. Click on the menu: File > Open > run_analysis.r
2. Click the "Source" button above the code area

### UCI HAR Dataset

The data downloaded for the *run_analysis* script comes the Machine Learning Repository in the Center for Machine Learning and Intelligent Systems at the University of California, Irvine.

You can view more information about the original and full dataset here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Dataset description, via the dataset's original README file: 

* The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 
* The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

#### UCI HAR Dataset Used Filelist

Not all files from the UCI HAR Dataset are used by *run_analysis* in the creation of the tidied data file.

Files used in *run_analysis*:

* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set
* 'train/y_train.txt': Training labels
* 'test/X_test.txt': Test set
* 'test/y_test.txt': Test labels
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

## Tidied Data

### Importing the tidied dataset

To import the dataset that *run_analysis* creates, use the following command:

* SamsungDataTidy <- read.table("samsungData_Tidy.txt", sep=" ")

### Tidied data structure

The tidied data is of the narrow-and-long form, and consists of four variables.

1. subject : The ID number of each participant in the data collection.
2. activity : A descriptive label for the type of activity the subject was engaging in for which measurements were taken.
3. metric : A descriptive label for the specific reading being taken by the measuring hardware.
4. metricValue : The average value for all observations of one subject performing one activity by that metric.

This data can be converted to wide-form tidy data through a function such as *dcast*.
An example would be: 

* castSamsungDataTidy <- dcast(SamsungDataTidy, subject+activity~metric, mean)