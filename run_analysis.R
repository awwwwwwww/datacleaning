## Title:       run_analysis.R
## Date:        10 August 2018
## Author:      Adam Weissman
## Description: Script to clean data from Samsung Galaxy S smartphone accelerometers
## Inputs:      None
## Returns:     None

run_analysis<-function(){
    #load libraries
    library(readr)
    
    # Setup constants
    dlzip="DCassignment.zip"
    dlurl="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    
    #Download data if it hasn't already been downloaded
    if(!file.exists(dlzip)){
        download.file(dlurl,dlzip)
        unzip(dlzip)
    } 
    # Set working directory as data root
    setwd("UCI HAR Dataset")
    
    # read in data from file
    activity_label<-read_table("activity_labels.txt",col_names=FALSE)
    features<-read_table("features.txt",col_names=FALSE)

    xtest <-read_table("test/X_test.txt",col_names=FALSE)
    ytest <-read_table("test/Y_test.txt",col_names=FALSE)
    subject_test<-read_table("test/subject_test.txt",col_names = FALSE)
    
    xtrain <-read_table("test/X_train.txt",col_names=FALSE)
    ytrain <-read_table("test/Y_train.txt",col_names=FALSE)
    subject_train<-read_table("test/subject_train.txt",col_names = FALSE)
    
}