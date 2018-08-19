## Title:       run_analysis.R
## Date:        10 August 2018
## Author:      Adam Weissman
## Description: Script to clean data from Samsung Galaxy S smartphone accelerometers
## Inputs:      None
## Returns:     Cleaned dataset

run_analysis<-function(){
    # load libraries
    library(readr)
    library(dplyr)
    
    # getting working directly to get back later
    oldwd<-getwd()
    
    # Setup constants
    dlzip="DCassignment.zip"
    dlurl="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    
    #Download data if it hasn't already been downloaded
    if(!file.exists(dlzip)){
        download.file(dlurl,dlzip)
        unzip(dlzip)
    } 
    # Set working directory as data root
    setwd("./UCI HAR Dataset")
    
    # read in data from file then set column names
    # first read the activity literals and feature (variable) names
    activity_label<-read_table("activity_labels.txt",col_names=FALSE)
    features<-read_table("features.txt",col_names=FALSE)

    # read in test data
    xtest <-read_table("test/X_test.txt",col_names=FALSE)
    # assign feature labels from first column of features to the test data
    colnames(xtest)<-features$X1
    # read in the activity labels corresponding to the test data
    ytest <-read_table("test/Y_test.txt",col_names=FALSE)
    # name this variable as Activity
    colnames(ytest)<-"Activity"
    # read in the corresponding subject identifier variable
    subject_test<-read_table("test/subject_test.txt",col_names = FALSE)
    # name the variable subject
    colnames(subject_test)<-"Subject"
    
    # I found R more cooperative when I combined my data with similar column names
    # read in the train data the same way as the test data
    xtrain <-read_table("train/X_train.txt",col_names=FALSE)
    colnames(xtrain)<-features$X1
    ytrain <-read_table("train/Y_train.txt",col_names=FALSE)
    colnames(ytrain)<-"Activity"
    subject_train<-read_table("train/subject_train.txt",col_names = FALSE)
    colnames(subject_train)<-"Subject"
    
    # keep only std and mean variables from data
    filteredTest<-xtest%>%select(matches("mean\\(|std\\("))
    filteredTrain<-xtrain%>%select(matches("mean\\(|std\\("))
    
    # add in which dataset it came from and the activity
    testdata<-cbind.data.frame(filteredTest,"Dataset"="test",ytest,subject_test)
    traindata<-cbind.data.frame(filteredTrain,"Dataset"="train",ytrain,subject_train)
    
    # merge the test and training dataset
    mergedset<-rbind.data.frame(testdata,traindata)
    
    # substitute Activity enumeration indecies with Activity string literal 
    mergedset$Activity<-activity_label$X2[mergedset$Activity]

    #reset wd as it was
    setwd(oldwd)
    
    return(mergedset)
}

## Title:       tidy_avgs
## Description: Script to return a dataset of the averages of each 
##              variable in the inputed dataset
## Inputs:      Tidy Samsung accelerometer dataset to be averaged by each 
##              subject and each activity
## Returns:     Dataset with the averages of each variable by each subject 
##              and activity
tidy_avgs<-function(dataset){
    # First group the data inputed by subject and activity then get the mean
    # for each variable except dataset (test/train literal), activity (grouping
    # variable), and subject (grouping variable) for each subject and activity
    tidyAvg<-dataset %>% group_by(Subject,Activity) %>% summarise_at(vars(-Dataset,-Activity,-Subject),funs(mean))
    return(tidyAvg)
}