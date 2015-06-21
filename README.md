# UCI-Human-Activity-Recognition-Tidy-Data
Getting &amp; cleaning the UCI Human Acitivity Recognition dataset: scripts &amp; how-to
author: "ktnewport"
date: "June 18, 2015"
output: pdf_document
---

Full description of the data, collection and methods, from the UCI Machine Learning Repository:
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

Zipped data link: <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

  The original UCI HAR README.txt may be found within the downloaded and unzipped file folders from the above web address.  The unzipped file folder "UCI HAR Dataset" contains several text documents and two subfolders: "test" and "train".  These two folders contain the 'messy' datasets to be stiched together and cleaned.  They were produced by randomly splitting the orginally collected data to 70% to the training dataset, and reserving 30% as the test dataset.  
  
  Within the first level folder, UCI HAR Dataset, the original measurement codes are found in the features.txt, and the information about the features (variable names) and the values they represent are found in the features_into.txt.  The subject_test.txt and subject_train.txt files represent the individual that wore the device that collected the measurements during the human activities.  The activity_labels.txt file in the first level of the UCI HAR Dataset folders contains the activities undertaken by the subjects corresponding to the activity code, found the y_test.txt or y_train.txt in the test or training folders.  Also in the test/train folders are the value measurements, X_test.txt and X_train.txt.  These are the raw data.  We will not be working with the Inertial Signals folders at this time.   

The R script also in this GitHub repo will execute all necessary steps to output a tidy data set: run_analysis.R.  The qualifications for producing this tidy dataset were as follows: 1) merges the training and test dataset into one dataset, 2) extracts only measurements of the mean and standard deviation for each measurement, 3) uses descriptive activity names for the activites in the dataset, 4) labels data with descriptive variable names, 5) creates the tidy dataset with average values of each variable for each activity and subject.  

The produced tidy dataset is also in this GitHub repo: "UCI_HAR_tidy_dataset.txt".  The steps and decisions to produce this dataset to meet the outlined qualifications are as follows:
1) Downloaded and unzipped the UCI HAR files outside of R, placed in desired working directory.  If this set of files is not in your current working directory, script will throw a warning message.
2) Loaded packages plyr and dplyr to R console.
3) Read in the y_test.txt as table.  Starting with test dataset since it will be smaller/ less RAM to process, so calls will be faster. 
4) Changed the column name to Activity, and added an ID variable column, rowNUM, simply to keep track of individual rows.
5) Read in subject data.
6) Changed column name to Subject_ID, and again added an ID variable, same as for the y_test.txt, since they will be merged together later and need a key column.
7) Merge the subject and activity columns together by the rowNum column, these are the two factors so far, in the dataset.
8) Create a dataframe of just the feature names from features.txt.
9) Read in the measurement values from x_test.txt, set column names to those from the features.txt file/ dataset.
10) Give the x_test dataset an identifier as well, rowNum as the others.
11) Merge the factor dataset and the measurement dataset, by the ID column rowNum so ensure nothing is lost or shuffled.  Final product is the entire test data set.
12 - 19) follow steps like for the test dataset, only regarding the training set.
20) Bind the test and training set togeth, with test_df going into the argument call first, since the rowNum ID column will then run from 1:2947 for the test portion, and 2948:10299 for the training portion.
21) Isolate the desired variables from the entire dataset.  I chose to include any variable whose name contained mean and std as per instructions, but not the mean frequency variables, since they were not true means of raw measurements (see the original features_into.txt).  Some of these variables included measurements after transformations were applied, and averaging a 'signal window sample', and therefore were not raw measurements, but since I am unfamiliar with this area science, I included all such variables, assuming they had significant value to analyses, otherwise would not have been produced.    
22-27) Re-labeling the activity codes to the activity names for clarity.
28) Denoting Activity as a factor variable.
29-34) Many calls to rename the columns.  Consistency in the variable names will be crucial in the upcoming calls to gather and separate cleanly.  
35) Load package tidyr.
36) Gather all data besides the Activity and Subject ID columns, since all variables names actually indicate 2-3 variables: the measurement, the type of measurement estimate (i.e. the mean or standard deviation), and sometimes the angular direction (X, Y, Z).  
37)  After the gather, separate the values twice, first by the measurement, and then by the estimate type and the angular direction.  Important to set the extra = "merge", or call will drop data.
38) Group by the subject, activity type, measurment, and measurement estimate type and summarize the values.  The call also includes arranging the tidy dataset by subect ID, activity, and measurement for ease of navigation.
39)  Writes data table to a txt file with comma separation: "UCI_HAR_dataset_tidy.txt".
40) Prints the tidy dataset to the console for review. 

See: UCI-HAR codebook for the final tidy dataset variables and variable codes. 
