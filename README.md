# Getting and Cleaning Data Course Project

## Goal of the Project

The goal of this project is to create a tidy data,
that can be used for later analysis,
from a set of data files to demonstrate the ability
to collect, work with, and clean a data set.

## Data Source

The data used for this project were collected from the accelerometers from
the Samsung Galaxy S smartphone in experiments on wearable computing.
The data file is availabe at the following link.

<a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip">https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip</a>

A full description of the above data is available at the following site and
resources referred there: 

<a href="http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones">http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones</a>

## Data Process Procedures

This file describes the R codes in the R script file <b>run\_analysis.R</b>
that, when executed, will process the data in the file from the above link
and create a tidy data set.
Please note that no external packages (such as dplyr)
are used in the script though some codes might be simplied
to some degree if some packages were used.

When you download and unzip the above data file,
a subdirectory named <b>UCI HAR Dataset</b> will be created
in the current directory and all the data files needed are under
the <b>UCI HAR Dataset</b>
subdirectory and its subdirectories <b>train</b> and <b>test</b>.
It is assumed that your R working directory contains the
<b>UCI HAR Dataset</b> subdirectory when you run the R script
(<b>source("run\_analysis.R"</b>)
and the tidy data set will be written in a file named <b>tidy\_data.txt</b>
in this working directory. 

In this repo, you will find four files:
* README.md: this file.
* run_analysis.R: the R script for processing the data sets
  and producing the tidy data set.
* tidy_data.txt: the tidy data set produced by the R script.
* CodeBook: document describing the tidy data set in tidy_data.txt.

### 1. Merge the training and test data sets

The training data are in the <b>train</b> subdirectory
and the test data in the <b>test</b>
subdirectory.  From each subdirectory,
The script reads in data from three files,
<b>subject\_train.txt</b>, <b>X\_train.txt</b> and <b>y\_train.txt</b>
for training and <b>subject\_test.txt</b>, <b>X\_test.txt</b>
and <b>y\_test.txt</b> for test.
The X file contains the measurements of variables and their means,
standard deviations, etc., of the subjects (volunteers for the experiments).
The subject file contains the subject IDs, each mapping a row in the X file
to a subject in the same order. The y file contains the activity IDs,
each mapping a row in the X file to a specific activity in the same order.

The script first reads the three files separately into three data frames,
as shown below, for example, for the training data.

>`train_subjs = read.table("train/subject_train.txt")`<br>
>`train_lbls = read.table("train/y_train.txt")`<br>
>`train_meas = read.table("train/X_train.txt", as.is=T)`

Note the option <b>as.is</b> is set to TRUE to read in the measurements
as numerics.

Then the three data frames are merged into one data frame named as
<b>train_data</b> with the subject
data in column 1, the activity data in column 2, and the measurement data
in the remaining columns, as shown below.

>`train_data = data.frame(train_subjs, train_lbls, train_meas)`

The same steps are taken to create a data frame named
<b>test_data</b> for the test data.
Then the two data frames are merged
to form one single data frame named <b>merged\_data</b>:

>`merged_data = rbind(train_data, test_data)`

Now we have a merged data set.

>&gt;dim(merged_data)
>[1] 10299   563

Plese note that you may see some codes to remove some objects with <b>rm()</b>
when they are no longer needed.

### 2. Extract means and standard deviations

The file <b>features.txt</b> contains names that specify the type of data
or signals for the corresponding columns in the X file (see 1. above).
Means and standard deviations can be identified by the substrings "-mean()"
and "-std()" respectively. So names are read in first from the file,
then <b>grep()</b> is used to get the column indexes
for the mean and standard deviation variables as well as their full names.

>`feature_cols = grep("-mean\\(\\)|-std\\(\\)", features$V2)`<br>
>`feature_names = grep("-mean\\(\\)|-std\\(\\)", features$V2, value=T)`

After the full name are sextracted , the names are cleaned a little bit
by removing the parenthese "()".

>`feature_names = gsub("\\(\\)","", feature_names)`

Because in the merged data frame the measurement columns are after
the subject and activity columns, the feature column indexes are adjusted
by increasing them by 2 and inserted subject and activity names
at the front feature name vector.

>`feature_cols = feature_cols + 2`<br>
>`feature_cols = c(1,2,feature_cols)`<br>
>`feature_names = c("subject", "activity", feature_names)`

Once the indexes are adjusted,
they are used to extract the mean and standard
deviation columns from the merged data frame along with the
subject and activity columns into a new data frame named <b>subsets\_data</b>.

>`subsets_data = merged_data[, feature_cols]`

Please note that <b>feature\_name</b> now has the descriptive names
for the corresponding variables (or columns) in <b>subsets\_data</b>.

### 3. Replace activity codes (levels in column 2) with descriptive names

The file <b>activity\_labels.txt</b> contains the description
for the activity codes, so first the descriptions are read in from the file.

>`activities = read.table("activity_labels.txt")`

Then the activity codes (or levels) in column 2 of <b>subsets\_data</b> 
are replaced with their corresponding descriptive names.
Here the activity codes in column 2 are simply used as the row selector
to select the corresponding rows in the activities table and
replace the activity codes with their corresponding descriptive names.

>`subsets_data[,2] = activities[subsets_data[,2],2]`

For the subject column (column 1), the subject ID numbers are kept.

### 4. Label variables (columns) with descriptive names

As noted above, the corresponding descriptive names for the variables
(or columns) in the subset data frame are in the vector <b>feature\_names</b>.
So it only needs to assign the names of the variables with
the values of the vector to give descriptive names to the variables:

>`names(subsets_data) = feature_names`

### 5. Create a tidy data set with the average of each variable for each activity of each subject from the table <b>subsets\_data</b>

What needed here is to replace the duplicated measurements of each variable
for each activity of each subject from the table <b>subsets\_data</b>
with their average, as illustraded below with subject 1, activity walking.
activity by subject 1 on three variables.

    > subsets_data[subsets_data$subject==1 & subsets_data$activity=="walking", 3:5]
    tBodyAcc-mean-X tBodyAcc-mean-Y tBodyAcc-mean-Z
          0.2820216   -0.0376962180     -0.13489730
          0.2558408   -0.0645500290     -0.09518634
          0.2548672    0.0038147234     -0.12365809
          ...
          0.3311724   -0.0286911150     -0.10839138
          0.1902231   -0.0388970510     -0.09869604
          0.2300388   -0.0220247770     -0.09787579

The above data will be replaced in the tidy data set with column means
produced as below.

    > colMeans(subsets_data[subsets_data$subject==1 & subsets_data$activity=="walking", 3:5])
    tBodyAcc-mean-X tBodyAcc-mean-Y tBodyAcc-mean-Z 
         0.27733076     -0.01738382     -0.11114810 

The codes are implemented with two nested loops.

>`means = data.frame()  # for the averages`<br>
>`subjs = integer(0)    # subjects`<br>
>`acts = character(0)   # activities`<br>

>`for(subj in 1:30) { # go through each subject`<br>
>&nbsp;&nbsp;&nbsp;&nbsp;`for(activity in activities[,2]) {  # go through each activity`<br>
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`subjs = c(subjs, subj)`<br>
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`acts = c(acts, activity)`<br>
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`avgs = colMeans(subsets_data[subsets_data[1]==subj & subsets_data[2]==activity, c(3:cols)])`<br>
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`means = rbind(means, avgs)`<br>
>&nbsp;&nbsp;&nbsp;&nbsp;`}`<br>
>`}`

The outer loop goes through each subject (from 1 to 30).
For each subject, the inner loop goes through each activity.
Using the subject and activity as the row selectors,
the codes in the inner loop extract the duplicated measurements
of each variable for the subject and activity
and apply <b>colMeans</b> function to get the average for each variable.
The subject, the activity and the averages are stored
in three objects <b>subjs</b>, <b>acts</b> and <b>means</b> respectively.

After the two loops finish, the three objects are combined into the final
data frame named <b>tidy\_data</b>.

>`tidy_data = data.frame(subject=subjs, activity = acts)`<br>
>`tidy_data = cbind(tidy_data, means)`

Then the variables (columns) in the tidy data frame are labeled with
the descriptive names and the tidy data set is written into a file with
<b>write.table()</b>.

>`names(tidy_data) =  feature_names`<br>
>`write.table(tidy_data, file = "tidy_data.txt", row.name = FALSE)`

The data set is in the wide form and can be read into R with the command
<b>read.table("tidy_data.txt", header=TRUE)</b>.

    > tidy_data = read.table("tidy_data.txt", header=T)
    > dim(tidy_data)
    [1] 180  68
    > head(tidy_data[, 1:8], 12)
       subject           activity tBodyAcc.mean.X tBodyAcc.mean.Y tBodyAcc.mean.Z tBodyAcc.std.X tBodyAcc.std.Y tBodyAcc.std.Z
    1        1            walking       0.2773308    -0.017383819      -0.1111481    -0.28374026    0.114461337    -0.26002790
    2        1   walking_upstairs       0.2554617    -0.023953149      -0.0973020    -0.35470803   -0.002320265    -0.01947924
    3        1 walking_downstairs       0.2891883    -0.009918505      -0.1075662     0.03003534   -0.031935943    -0.23043421
    4        1            sitting       0.2612376    -0.001308288      -0.1045442    -0.97722901   -0.922618642    -0.93958629
    5        1           standing       0.2789176    -0.016137590      -0.1106018    -0.99575990   -0.973190056    -0.97977588
    6        1             laying       0.2215982    -0.040513953      -0.1132036    -0.92805647   -0.836827406    -0.82606140
    7        2            walking       0.2764266    -0.018594920      -0.1055004    -0.42364284   -0.078091253    -0.42525752
    8        2   walking_upstairs       0.2471648    -0.021412113      -0.1525139    -0.30437641    0.108027280    -0.11212102
    9        2 walking_downstairs       0.2776153    -0.022661416      -0.1168129     0.04636668    0.262881789    -0.10283791
    10       2            sitting       0.2770874    -0.015687994      -0.1092183    -0.98682228   -0.950704499    -0.95982817
    11       2           standing       0.2779115    -0.018420827      -0.1059085    -0.98727189   -0.957304989    -0.94974185
    12       2             laying       0.2813734    -0.018158740      -0.1072456    -0.97405946   -0.980277399    -0.98423330
