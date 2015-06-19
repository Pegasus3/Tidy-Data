This readme file explains the code and describes why this specific approach was followed.  

The data for this project were unzipped into a project directory from a zip file called "getdata_projectfiles_UCI HAR Dataset.zip"

The first step in writing "run_analysis.R" was to read "X_train.txt" into R - using read.table - followed with the reading of the "X_test.txt" file and r-binding both files into a data frame called "tidy".  This data frame formed the basic structure for the project.

The second step was actually step No 3 in the assignment and it made sense to implement this first in the code in order to see the names of the variables (columns) and to decide how to go about extracting the measurements on the mean and standard deviation as requested in step No 2.  The file containing the names of the variables was "features.txt."

The file "features.txt" was downloaded into R using read.table with stringsAsFactors = FALSE because without this restriction, Factors were proving to be problematic for the program.  These variable names were read into a character vector which was then inserted as a header into the "tidy" data frame.

Now it was easy to inspect the column names and identify the columns needed and proceed with step 2 of the assignment.  To keep the columns involving the "-mean()" or "-std()" strings the unique() function was employed along with grep.  This search however also returned columns with the string "meanFreq()" and such columns were not needed for the requested task.  As a result an additional separate search was performed to identify the columns having the name "meanFreq()" values  and to subtract these columns from the previous finding using the setdiff() function.  The unwanted columns were then deleted from the "tidy" data frame.

In step 4 two more columns were added to the "tidy" data frame.   One column was the identification number of the volunteer (subject) who participated in the project and these numbers ranged from 1 to 30.  The second column was a number between 1 to 6 and signified the Activity that was monitored at the time - activities such as Walking, Walking Upstairs, Walking Downstairs etc.

The identification numbers of the volunteers were read  using read.table from the files  "subject_train.txt" and "subject_test.txt."  The files were read into a data frame called sub using rbind under the column name "subject."  This data frame was then added to the "tidy" data frame using the cbind function.

The Activity numbers, 1 to 6, were read from the files "y_train.txt" and "y_test.txt" using read.table and combined into a data frame under the column name "activity."    The actual names of the activities themselves were obtained from the file "activity_labels.txt" and a "for loop" was used to replace the activity numbers with the label of each activity and passed into a character vector named "activity".   The character vector "activity" was in turn combined with the "tidy" data frame using cbind. 

For step No 5 a second, independent tidy data set was obtained, using the aggregate function - named "tidy_no2" -  with the average of each variable for each activity and each subject.  The aggregate function was chosen because it gave positive results right away.  The only problem was that it renamed the "subject" and "activity" columns as "Group.1" and "Group.2" and that was corrected right away using rename from the the plyr library.

The data frame "tidy_no2",  was printed as a text file  "tidy_no2.txt", using the write.table function with row.name=FALSE. 

