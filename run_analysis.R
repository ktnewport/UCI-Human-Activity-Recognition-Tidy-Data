## Check to be sure the Human Activity Dataset 
## zip has been downloaded and exists in the current
## working directory.  If not, system sends warning
## message: "UCI HAR Dataset is not in working
## directory!".
if(!file.exists("UCI HAR Dataset")){
  stop("UCI HAR Dataset is not in working directory!")
}
## Load the plyr and dplyr packages into R, in that order.
library(plyr)
library(dplyr)
## First, load the y_test text file into a dataframe.
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
## Chain dplyr calls, first renames variable,
## then creates a new column, rowNum, to base merge on, 
## simply the row number, since # of rows is the same.
y_test<-y_test %>%rename(Activity = V1) %>% mutate(rowNum = c(1:2947))
## Loading the subject_test text file into a dataframe
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
## Chain dplyr calls, renames variable, then creates the 
## row number column rowNum.
subject_test<-subject_test %>%rename(Subject_ID = V1) %>% mutate(rowNum = c(1:2947))
## Merging the factor variables into one dataframe by the
## "rowNum" column.
factors_test<- merge(subject_test, y_test, by= "rowNum", all = TRUE)
## Getting the variable names, called features
## from 'features.txt' file.
testnames<-read.table("./UCI HAR Dataset/features.txt")
## Reading in the large dataset 'x_test.txt' into a 
## dataframe.  Will take a bit of time.  Call 
## sets column/ variable names to features.
x_test<-read.table("./UCI HAR Dataset/test/x_test.txt", col.names = testnames$V2)
## Create the rowNum in the x_test dataframe.
x_test<- mutate(x_test, rowNum= c(1:2947))
## Merge the factors_test dataframe and the large
## x_test dataframe, now all test data is in test_df dataframe.
test_df<- merge(factors_test, x_test, by = "rowNum", all = T)
## The training dataset, same routine, different names.
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
y_train<-y_train %>%rename(Activity = V1) %>% mutate(rowNum = c(2948:10299))
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_train<-subject_train %>%rename(Subject_ID = V1) %>% mutate(rowNum = c(2948:10299))
factors_train<- merge(subject_train, y_train, by= "rowNum", all = TRUE)
x_train<-read.table("./UCI HAR Dataset/train/x_train.txt", col.names = testnames$V2)
## I increased the rowNum in order to be combined,
## to be sure I didn't overwrite any data.
x_train<- mutate(x_train, rowNum= c(2948:10299))
train_df<- merge(factors_train, x_train, by = "rowNum", all = T)
## All together now...bind_rows will combine
## both the test_df & train_df into one dataframe.
HAtestANDtrain_df<-bind_rows(test_df, train_df)
## Isolate subject, activity, mean & std variables,
## but not the meanFreq, since that is not a pure of
## a measurement but the frequency components of the 
## measurement.
isolate<- select(HAtestANDtrain_df, Subject_ID, Activity, contains("mean"), contains("std"), -contains("Freq"))
## Replacing the Activity numeric code with 
## descriptive character labels.
isolate$Activity[isolate$Activity == 1]<- "Walking"
isolate$Activity[isolate$Activity == 2]<- "Walking_Upstairs"
isolate$Activity[isolate$Activity == 3]<- "Walking_Downstairs"
isolate$Activity[isolate$Activity == 4]<- "Sitting"
isolate$Activity[isolate$Activity == 5]<- "Standing"
isolate$Activity[isolate$Activity == 6]<- "Laying"
## Making those labels into factors.
isolate_factor<- mutate(isolate, Activity = as.factor(Activity))
## OK, this is going to suck.  The column names
## don't have the same format, but they should.
## This is important for a subsequent step that
## will separate these long-ass column names into 
## meaningful factors.  Means we have to rename
## them, ~20 out of 75 variables, so it could
## be worse.  What do you care, I'm the one doing
## all the typing!  I do hope you can figure out why
## these renames are broken up and not continually chained...
isolate_factor<-isolate_factor%>% 
  rename(tBodyAccMag.mean...NA = tBodyAccMag.mean..)%>%
  rename(tGravityAccMag.mean...NA = tGravityAccMag.mean..) %>% 
  rename(tBodyAccJerkMag.mean...NA = tBodyAccJerkMag.mean..) %>% 
  rename(tBodyGyroMag.mean...NA = tBodyGyroMag.mean..) %>% 
  rename(tBodyGyroJerkMag.mean...NA = tBodyGyroJerkMag.mean..)
isolate_factor<-isolate_factor%>% 
  rename(fBodyAccMag.mean...NA = fBodyAccMag.mean..)%>%
  rename(fBodyBodyAccJerkMag.mean...NA = fBodyBodyAccJerkMag.mean..) %>% 
  rename(fBodyBodyGyroMag.mean...NA = fBodyBodyGyroMag.mean..) %>% 
  rename(fBodyBodyGyroJerkMag.mean...NA = fBodyBodyGyroJerkMag.mean..) 
isolate_factor<-isolate_factor%>% 
  rename(tBodyAccAngleGravity.mean...NA = angle.tBodyAccMean.gravity.) %>% 
  rename(tBodyAccJerkAngleGravity.mean...NA = angle.tBodyAccJerkMean..gravityMean.) %>% 
  rename(tBodyGyroAngleGravity.mean...NA = angle.tBodyGyroMean.gravityMean.) %>% 
  rename(tBodyGyroJerkAngleGravity.mean...NA = angle.tBodyGyroJerkMean.gravityMean.)
isolate_factor<- isolate_factor %>% 
  rename(AngleGravity.mean...X = angle.X.gravityMean.) %>% 
  rename(AngleGravity.mean...Y = angle.Y.gravityMean.) %>% 
  rename(AngleGravity.mean...Z = angle.Z.gravityMean.)
isolate_factor<- isolate_factor %>% 
  rename(tBodyAccMag.std...NA = tBodyAccMag.std..) %>% 
  rename(tGravityAccMag.std...NA = tGravityAccMag.std..) %>% 
  rename(tBodyAccJerkMag.std...NA = tBodyAccJerkMag.std..) %>% 
  rename(tBodyGyroMag.std...NA = tBodyGyroMag.std..) %>% 
  rename(tBodyGyroJerkMag.std...NA = tBodyGyroJerkMag.std..)
isolate_factor<- isolate_factor %>% 
  rename(fBodyAccMag.std...NA = fBodyAccMag.std..)%>% 
  rename(fBodyBodyAccJerkMag.std...NA = fBodyBodyAccJerkMag.std..) %>% 
  rename(fBodyBodyGyroMag.std...NA = fBodyBodyGyroMag.std..) %>% 
  rename(fBodyBodyGyroJerkMag.std...NA = fBodyBodyGyroJerkMag.std..) 
## Loading package tidyr comes first.
library(tidyr)
## Now, to gather and separate the measurement variables, 
## the type of estimate, and their angular directions, 
## which are erroneously lumped together into single columns, 
## denoted by X, Y, Z, or NA, in two events.
tidy_gather<-gather(isolate_factor, key, M_Value, -Activity, - Subject_ID)
## And separating. 
tidier<- tidy_gather %>% 
  separate(col = key, into = c("Measurement", "Estimate_Direction"), extra = "merge") %>% 
  separate (col =Estimate_Direction, into = c("M_Estimate", "Angular_Direction"), extra = "merge")
## Now, first group by the variables we care 
## about: the subject, the activity, the
## measurement type, the measurement estimate type,
## and then summarize the mean of the measured values.
## Final touch includes arranging the tidiest 
## data set by subject, activity, and the measurement type.
tidiest<- tidier%>% 
  group_by(Subject_ID, Activity, Measurement, M_Estimate) %>%
  summarize(Average_Measurement = mean(M_Value))%>%
  arrange(Subject_ID, Activity, Measurement)
## Here we export the dataframe into a txt file,
## ready for uploading. 
write.table(tidiest, file = "UCI_HAR_tidy_dataset.txt", row.names = FALSE, col.names = TRUE, sep = ",")
print(tidiest)