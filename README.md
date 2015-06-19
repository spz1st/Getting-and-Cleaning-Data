# Getting and Cleaning Data Course Project
This file describes the R codes in the R script file <b>run\_analysis.R</b>
that, when executed, will process the data in the file available
at the following link and create a tidy data set.
<p>
<a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip">https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip</a>

A full description of the above data is available at the following site: 

<a href="http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones">http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones</a>

When you download and unzip the above data file,
a new directory named <b>UCI HAR Dataset</b> will be created
in the current directory and all the data files needed are put under
the <b>UCI HAR Dataset</b>
directory and its subdirectories <b>train</b> and <b>test</b>.
It is assumed that your R working directory is
<b>&lt;path\_from\_root&gt;/UCI HAR Dataset</b> when you run the R script (source("run\_analysis.R"))
and the tidy data set will be written in a file named <b>tidy\_data.txt</b>
in this working directory. 
A copy of the file has been loaded into this repo.

## 1. Merge the training and test data sets

The training data are in the train subdirectory and the test data in the test
subdirectory.  From each subdirectory,
we read in data from three files,
subject\_train.txt, X\_train.txt and y\_train.txt for training and 
subject\_test.txt, X\_test.txt and y\_test.txt for test.
The X file contains the measurements of variables and their means,
standard deviations, etc of the subjects. The subject file contains
the subject IDs, each mapping a row in the X file
to a subject in the same order. The y file contains the activity IDs,
each mapping a row in the X file to a specific activity in the same order.

The script first reads the three files separately into three data frames,
as shown below for the training data.

>`train_subjs = read.table("train/subject_train.txt")`<br>
>`train_lbls = read.table("train/y_train.txt")`<br>
>`train_meas = read.table("train/X_train.txt", as.is=T)`

Note the option as.is is set to TRUE to read in the measurements as numerics.

Then the three data frames are merged into one data frame named as
<b>train_data</b> with the subject
data in column 1, the activity data in column 2, and the measurement data
in the remaining columns, as shown below.

>`train_data = data.frame(train_subjs, train_lbls, train_meas)`

We do the same to create a data frame named <b>test_data</b> for the test data.
Then the two data frames are merged
to form one single data frame named <b>merged\_data</b>:

>`merged_data = rbind(train_data, test_data)`

Note the codes will remove some objects when they're no longer needed.

## 2. Extract means and standard deviations

The file features.txt contains names that specify the type of data for
the corresponding columns in the X file (see 1. above).
Means and standard deviations can be identified by the substrings "-mean()"
and "-std()" respectively. So we first read in names from the file,
then use grep to get the column indexes
for the mean and standard deviation variables as well as their full names.

>`feature_cols = grep("-mean\\(\\)|-std\\(\\)", features$V2)`<br>
>`feature_names = grep("-mean\\(\\)|-std\\(\\)", features$V2, value=T)`

After we extracted the full names, we cleaned the names a little bit
by removing the parenthese "()".

>`feature_names = gsub("\\(\\)","", feature_names)`

Because in the merged data frame, the measurement columns are after
the subject and activity columns, we adjusted the feature column indexes
by increasing them by 2 and inserted subject and activity names
at the front feature name vector.

>`feature_cols = feature_cols + 2`<br>
>`feature_cols = c(1,2,feature_cols)`<br>
>`feature_names = c("subject", "activity", feature_names)`

Once the indexes are adjusted,
we applied the column indexes to extract the mean and standard
deviation columns from the merged data frame along with the
subject and activity columns into a new data frame
named subsets_data.

>`subsets_data = merged_data[, feature_cols]`

Please note that <b>feature\_name</b> now has the descriptive names
for the corresponding variables (or columns) in <b>subsets\_data</b>.

## 3. Replace activity codes (levels in column 2) with descriptive names

The file <b>activity\_labels.txt</b> contains the description
for the activity codes, so we first read in the descriptions from the file.

>`activities = read.table("activity_labels.txt")`

Then we replaced the activity codes (or levels) in the column of 2 of
the subset data frame with their corresponding descriptive names.
Here we simply use the activity codes in column 2 as the row selector
to select the corresponding rows in the activities table and
replace the activity codes with their corresponding descriptive names.

>`subsets_data[,2] = activities[subsets_data[,2],2]`

For subjuect column (column 1), we just keep the subject ID number.

## 4. Label variables (columns) with descriptive names

As noted above, the corresponding descriptive names for the variables
(or columns) in the subset data frame are in the vector <b>feature\_names</b>.
So we only need to assign the names of the variables with
the values of the vector:

>`names(subsets_data) = feature_names`

## 5. Create a tidy data set with the average of each variable for each activity of each subject from the table <b>subsets\_data</b>

What needed here is to replace the duplicated measurements of each variable
for each activity of each subject from the table <b>subsets\_data</b>
with their average. We implemented the codes with two nested loops.

>`means = data.frame()  # for the averages`<br>
>`subjs = integer(0)    # subjects`<br>
>`acts = character(0)   # activities`<br>

>`for(subj in 1:30) { # go through each subject`<br>
>&nbsp;&nbsp;&nbsp;&nbsp;`for(activity in activities[,2]) {  # go through each activity`<br>
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`subjs = c(subjs, subj)`<br>
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`acts = c(acts, activity)`<br>
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`avgs = sapply(subsets_data[subsets_data[1]==subj & subsets_data[2]==activity, c(3:cols)], mean)`<br>
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`means = rbind(means, avgs)`<br>
>&nbsp;&nbsp;&nbsp;&nbsp;`}`<br>
>`}`

The outer loop goes through each subject (from 1 to 30).
For each subject, the inner loop goes through each activity.
Using the subject and activity as the row selectors,
the codes in the inner loop extract the duplicated measurements
of each variable for the subject and activity
and apply <b>sapply</b> function to get the average for each variable.
We stored the subject, the activity and the averages
in three objects <b>subjs</b>, <b>acts</b> and <b>means</b> respectively.

After the two loops finish, we combined the three objects into the final
data frame named <b>tidy\_data</b>.

>`tidy_data = data.frame(subject=subjs, activity = acts)`<br>
>`tidy_data = cbind(tidy_data, means)`

Then we labels the variables (columns) in the tidy data frame with
the descriptive names and write the tidy data set into a file with
<b>write.table()</b>.

>`names(tidy_data) =  feature_names`<br>
>`write.table(tidy_data, file = "tidy_data.txt", row.name = FALSE)`
