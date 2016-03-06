# GettingAndCleaningData
Project for Coursera Getting and Cleaning Data Course

Contents: 
run_analysis.R:
 - will run when working directory is "UCI HAR Dataset" (it will look in the test/train subdirectories)

Operation of run_analysis.R:
1. combines test and training data from the UCI HAR dataset
2. extracts features that are the mean or standard deviation of a quantity within the test/training data sets
3. expands feature names to make them more human-readable
4. summarizes the features extracted in step 2 and prints the summary to a file

