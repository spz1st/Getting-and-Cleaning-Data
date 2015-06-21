# try to process the data without using dplyr and tidyr
# library(dplyr)
# library(tidyr)

# X_test.txt  contains the measurements
# y_test.txt  contains activities code (1 to 6) in active_labels.txt
# subject_test.txt contains subject id (1 to 30)

# read in train data

####### step 1. read in training and test datasets and merge

### read in training dataset

train_subjs = read.table("train/subject_train.txt")# subjects within 1 to 30
train_lbls = read.table("train/y_train.txt") # activity code within 1 to 6
train_meas = read.table("train/X_train.txt", as.is=T) # measurements, 561 variables

# combine the data into a single data.frame
# columns in order of "subject", "activity", "measure1", "measure2", ...

train_data = data.frame(train_subjs, train_lbls, train_meas)

# clean up tables not needed any more

rm(train_meas)
rm(train_subjs)
rm(train_lbls)

### read in test data (follow the same steps as for training dataset)

test_subjs = read.table("test/subject_test.txt") # subjects within 1 to 30
test_lbls = read.table("test/y_test.txt")  # activity code within 1 to 6
test_meas = read.table("test/X_test.txt", as.is=T)  # measurements, 561 variables

# combine the data into a data.frame
# columns in order of "subject", "activity", "measure1", "measure2", ...

test_data = data.frame(test_subjs, test_lbls, test_meas)

# clean up tables not needed any more

rm(test_meas)
rm(test_subjs)
rm(test_lbls)

### merge train and test datasets into a single data frame

merged_data = rbind(train_data, test_data)
# >dim(merged_data)
# [1] 10299   563

# clean up tables not needed any more

rm(train_data)
rm(test_data)

####### step 2. extract means and standard deviations

### read in describle variable names for 561 measurements

features = read.table("features.txt")

# > names(features)
# [1] "V1" "V2"
# > head(features,3)
#   V1                V2
# 1  1 tBodyAcc-mean()-X
# 2  2 tBodyAcc-mean()-Y
# 3  3 tBodyAcc-mean()-Z

### get the indexes for the means and standand deviations

feature_cols = grep("-mean\\(\\)|-std\\(\\)", features$V2) # get the indexes

## get the corresponting descriptive variable names to be used in step 4

feature_names = grep("-mean\\(\\)|-std\\(\\)", features$V2, value=T)
feature_names = gsub("\\(\\)","", feature_names) # remove () from the names

### must add the subject and activity indexes, which is 1 and 2

# but first need to adjust the column indexes
# because two columns (subject and activity) were inserted at front,
# we increase the original column indexes by 2

feature_cols = feature_cols + 2

feature_cols = c(1,2,feature_cols)  # add the indexes of subject and activity columns

### must also add the subject and activity names

feature_names = c("subject", "activity", feature_names)

### now extract the mean and standard deviation, plus subject and activitity

subsets_data = merged_data[, feature_cols]

# > dim(subsets_data)
# [1] 10299    68
# > sum(!complete.cases(subsets_data))
# [1] 0
# no NAs in the data set

# clean up tables not used any more

rm(merged_data)

###### step 3. name activity (column 2) with descriptive names

### read in the active names
activities = read.table("activity_labels.txt")
# >activities
#   V1                 V2
# 1  1            WALKING
# 2  2   WALKING_UPSTAIRS
# 3  3 WALKING_DOWNSTAIRS
# 4  4            SITTING
# 5  5           STANDING
# 6  6             LAYING

## convert upper cases to lower cases; can be skipped if upper case preferred

activities[,2] = tolower(activities[,2])

### convert activity codes (column 2) to descriptive activity names
# here we simply use the activity codes in column 2 as the row select
# to select the corresponding rows in the activities table and 
# replace the activity codes with their corresponding descriptive names.
# for subjuect column, we just keep the subject ID number.

# > head(subsets_data[, 1:5], 3)
#   V1 V1.1      V1.2          V2         V3
# 1  1    5 0.2885845 -0.02029417 -0.1329051
# 2  1    5 0.2784188 -0.01641057 -0.1235202
# 3  1    5 0.2796531 -0.01946716 -0.1134617

subsets_data[,2] = activities[subsets_data[,2],2]

# > head(subsets_data[, 1:5], 3)
#   V1     V1.1      V1.2          V2         V3
# 1  1 standing 0.2885845 -0.02029417 -0.1329051
# 2  1 standing 0.2784188 -0.01641057 -0.1235202
# 3  1 standing 0.2796531 -0.01946716 -0.1134617

###### step 4. label the dataset (columns) with descriptive variable names. 

# just name the variables (columns) with the corresponding feature names

names(subsets_data) =  feature_names

# > head(subsets_data[, 1:5], 3)
#   subject activity tBodyAcc-mean-X tBodyAcc-mean-Y tBodyAcc-mean-Z
# 1       1 standing       0.2885845     -0.02029417      -0.1329051
# 2       1 standing       0.2784188     -0.01641057      -0.1235202
# 3       1 standing       0.2796531     -0.01946716      -0.1134617

###### step 5. create a tidy data set with the average of each variable
######         for each activity and each subject.

## this is just to replace the values of each measurement mean for each
## activity with a single value of their average, resulting a tidy data set
## in the wide form

cols = ncol(subsets_data)

means = data.frame()  # for the averages
subjs = integer(0)    # subjects
acts = character(0)   # activities

for(subj in 1:30) { # go through each subject
  for(activity in activities[,2]) {  # go through each activity
    subjs = c(subjs, subj)
    acts = c(acts, activity)

    # get the means of the duplicates for each variable (column)
    avgs = colMeans(subsets_data[subsets_data[1]==subj & subsets_data[2]==activity, c(3:cols)])
    means = rbind(means, avgs)
  }
}

### create the tidy data as a dataframe
# first create the dataframe with two columns: subject and activity

tidy_data = data.frame(subject=subjs, activity = acts)

# then add the average columns to form a tidy data set in wide form

tidy_data = cbind(tidy_data, means)

names(tidy_data) =  feature_names # properly name the variables

# for the tidy data set, the variable names for averages could be changed
# a little bit to reflect the average nature by doing the follow, for example
# names(tidy_data) = paste(names(tidy_data), "avg", sep="-")
# so tBodyAcc-mean-X would be changed to tBodyAcc-mean-X-avg

### write the tidy data set into a file

write.table(tidy_data, file = "tidy_data.txt", row.name = FALSE)

# clean up tables not used any more

rm(avgs)
rm(subjs)
rm(acts)
rm(means)
rm(tidy_data)

