Getting and Cleaning Data - Course Project

The R script, run_analysis.R, does the following:


01. It downloads the dataset if it is not already existing in the current working directory

02. Loads all the relevant datasets 

03. Loads both the training and test datasets and keeps only the columns that reflect a mean or standard deviatio 

04. Loads activity and subject data for each dataset and merges those columns with the dataset 

05. Merges the two datasets 

06. Converts the activity and the subject columns into factors 

07. Creates and tidy data set named tidy.txt
