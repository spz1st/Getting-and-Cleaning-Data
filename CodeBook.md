## CodeBook

Thi document describes the origional data (briefly),
the structure and the variables of the tidy data set.
Some info is also described in the <b>README.md</b> file.

### The Original Data

The original data sets, when unpacked from the zip file,
are divided in two subdirectories, train and test.
Each subdirectory contains three data files (in addition to others),
named <b>subject\_*.txt</b>, <b>y\_*.txt</b> and <b>X\_*.txt</b>, respectively.
The X files contain the measurements (561 columns).
The subject files contain the subject code (in the range of 1 to 30)
and the y files contain the activity code (in the rang of 1 to 6).
Each row in the subject file and y file corresponds to each row in X file.
The merged data frame should contain N rows and 563 columns.
 
The full descriptions of the experiments and the data sets are available
at the following website.

<a href="http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones">http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones</a>

### Work Performed to Produce the Tidy Data Set

Please see the <b>README.md</b> file and the R script <b>run\_analysis.R</b>.

The R script, when sourced, will produce the tidy data set
and write it in the file <b>tidy\_data.txt</b>.

### Structure of the Tidy Data Set

The tidy data set in the file <b>tidy\_data.txt</b>
is in the wide form, instead of being
a level of some factor variable (say signal.type),
each signal type, such as <b>tBodyAcc.mean.X</b>,
is made a variable (a column name).
The rows are ordered by first the subject (volunteer) code (1 to 30), then the activity code (1 to 6).  The columns after the first two are in the same order as in the X files.
The code to read the data set into R is
<b>tidy\_data = read.table("tidy\_data.txt", header=T)</b>.
The following R codes and outputs give you a glimpse of the data set.

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

### Description of Variable Names

The following table lists the descriptive variable (column) names
in the tidy data set.
Each variable other than <b>subject</b> and <b>activity</b>
is the average of the data for each signal type
(see <b>Definition of Variable Name Elements</b> below).

<table>
<tr>
<th>Column #</th>
<th>Variable Name</th>
<th width="100"></th>
<th>Column #</th>
<th>Variable Name</th>
</tr>
<tr><td class="col">1</td><td>subject</td><td></td><td class="col">35</td><td>tGravityAccMag-mean</td></tr>
<tr><td class="col">2</td><td>activity</td><td></td><td class="col">36</td><td>tGravityAccMag-std</td></tr>
<tr><td class="col">3</td><td>tBodyAcc-mean-X</td><td></td><td class="col">37</td><td>tBodyAccJerkMag-mean</td></tr>
<tr><td class="col">4</td><td>tBodyAcc-mean-Y</td><td></td><td class="col">38</td><td>tBodyAccJerkMag-std</td></tr>
<tr><td class="col">5</td><td>tBodyAcc-mean-Z</td><td></td><td class="col">39</td><td>tBodyGyroMag-mean</td></tr>
<tr><td class="col">6</td><td>tBodyAcc-std-X</td><td></td><td class="col">40</td><td>tBodyGyroMag-std</td></tr>
<tr><td class="col">7</td><td>tBodyAcc-std-Y</td><td></td><td class="col">41</td><td>tBodyGyroJerkMag-mean</td></tr>
<tr><td class="col">8</td><td>tBodyAcc-std-Z</td><td></td><td class="col">42</td><td>tBodyGyroJerkMag-std</td></tr>
<tr><td class="col">9</td><td>tGravityAcc-mean-X</td><td></td><td class="col">43</td><td>fBodyAcc-mean-X</td></tr>
<tr><td class="col">10</td><td>tGravityAcc-mean-Y</td><td></td><td class="col">44</td><td>fBodyAcc-mean-Y</td></tr>
<tr><td class="col">11</td><td>tGravityAcc-mean-Z</td><td></td><td class="col">45</td><td>fBodyAcc-mean-Z</td></tr>
<tr><td class="col">12</td><td>tGravityAcc-std-X</td><td></td><td class="col">46</td><td>fBodyAcc-std-X</td></tr>
<tr><td class="col">13</td><td>tGravityAcc-std-Y</td><td></td><td class="col">47</td><td>fBodyAcc-std-Y</td></tr>
<tr><td class="col">14</td><td>tGravityAcc-std-Z</td><td></td><td class="col">48</td><td>fBodyAcc-std-Z</td></tr>
<tr><td class="col">15</td><td>tBodyAccJerk-mean-X</td><td></td><td class="col">49</td><td>fBodyAccJerk-mean-X</td></tr>
<tr><td class="col">16</td><td>tBodyAccJerk-mean-Y</td><td></td><td class="col">50</td><td>fBodyAccJerk-mean-Y</td></tr>
<tr><td class="col">17</td><td>tBodyAccJerk-mean-Z</td><td></td><td class="col">51</td><td>fBodyAccJerk-mean-Z</td></tr>
<tr><td class="col">18</td><td>tBodyAccJerk-std-X</td><td></td><td class="col">52</td><td>fBodyAccJerk-std-X</td></tr>
<tr><td class="col">19</td><td>tBodyAccJerk-std-Y</td><td></td><td class="col">53</td><td>fBodyAccJerk-std-Y</td></tr>
<tr><td class="col">20</td><td>tBodyAccJerk-std-Z</td><td></td><td class="col">54</td><td>fBodyAccJerk-std-Z</td></tr>
<tr><td class="col">21</td><td>tBodyGyro-mean-X</td><td></td><td class="col">55</td><td>fBodyGyro-mean-X</td></tr>
<tr><td class="col">22</td><td>tBodyGyro-mean-Y</td><td></td><td class="col">56</td><td>fBodyGyro-mean-Y</td></tr>
<tr><td class="col">23</td><td>tBodyGyro-mean-Z</td><td></td><td class="col">57</td><td>fBodyGyro-mean-Z</td></tr>
<tr><td class="col">24</td><td>tBodyGyro-std-X</td><td></td><td class="col">58</td><td>fBodyGyro-std-X</td></tr>
<tr><td class="col">25</td><td>tBodyGyro-std-Y</td><td></td><td class="col">59</td><td>fBodyGyro-std-Y</td></tr>
<tr><td class="col">26</td><td>tBodyGyro-std-Z</td><td></td><td class="col">60</td><td>fBodyGyro-std-Z</td></tr>
<tr><td class="col">27</td><td>tBodyGyroJerk-mean-X</td><td></td><td class="col">61</td><td>fBodyAccMag-mean</td></tr>
<tr><td class="col">28</td><td>tBodyGyroJerk-mean-Y</td><td></td><td class="col">62</td><td>fBodyAccMag-std</td></tr>
<tr><td class="col">29</td><td>tBodyGyroJerk-mean-Z</td><td></td><td class="col">63</td><td>fBodyBodyAccJerkMag-mean</td></tr>
<tr><td class="col">30</td><td>tBodyGyroJerk-std-X</td><td></td><td class="col">64</td><td>fBodyBodyAccJerkMag-std</td></tr>
<tr><td class="col">31</td><td>tBodyGyroJerk-std-Y</td><td></td><td class="col">65</td><td>fBodyBodyGyroMag-mean</td></tr>
<tr><td class="col">32</td><td>tBodyGyroJerk-std-Z</td><td></td><td class="col">66</td><td>fBodyBodyGyroMag-std</td></tr>
<tr><td class="col">33</td><td>tBodyAccMag-mean</td><td></td><td class="col">67</td><td>fBodyBodyGyroJerkMag-mean</td></tr>
<tr><td class="col">34</td><td>tBodyAccMag-std</td><td></td><td class="col">68</td><td>fBodyBodyGyroJerkMag-std</td></tr>
<table>

### Definition of Variable Name Elements

* <b>subject</b>: code ID of the 30 volunteers participated in the experiments.
* <b>activity</b>: type of activities (walking, walking\_upstairs, walking\_downstairs, sitting, standing, or laying)
* <b>mean</b>: signal means
* <b>std</b>: signal standard deviations
* <b>BodyAcc</b>: data from linear body acceleration signals
* <b>GravityAcc</b>: data from linear gravity acceleration signals
* <b>BodyGyro</b>: data from gyroscope signals (body angular velocity)
* <b>Mag</b>: magnitude of the signals calculated using Euclidean norm
* <b>Jerk</b>: jerk signals derived from body velocity
* <b>a prefix 't'</b>: signals in time domain
* <b>a prefix 'f'</b>: signals produced by a Fast Fourier Transform
* <b>X, Y, Z</b>: signals from X, Y and Z axis respectively

For example, <b>tBodyAcc-mean-X</b> is the average for the signal
means from body acceleration in time domain along the x-axis
while <b>fBodyGyro-std-Y</b> is the average for the standard
deviations of Fast Fourier Transformed signals from body gyroscope along
y-axis.

