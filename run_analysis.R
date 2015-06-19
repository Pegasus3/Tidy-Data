 ## ===========================##
 ## Getting And Cleaning Data  ##
 ##   run_analysis.R           ##
 ##============================##

######################################################################
## You should create one R script called run_analysis.R that does the 
## following....  
#######################################################################

 setwd("C:/Computer Tools/R_Language/JHopkins3_Clean_Data/Project/UCI HAR Dataset")
 getwd()
 library(plyr)

 ############
 ## Step 1:  Merges the training and the test sets to create one data set.

 ## Read the data - train/X_train.txt
 file <- "C:/Computer Tools/R_Language/JHopkins3_Clean_Data/Project/UCI HAR Dataset/train/X_train.txt"
 tidy <- read.table(file) # Note: "tidy" is a data frame

 ## Read the test/X_test.txt data and bind them to the train data
 file <- "C:/Computer Tools/R_Language/JHopkins3_Clean_Data/Project/UCI HAR Dataset/test/X_test.txt"
 tidy <- rbind(tidy, read.table(file))

 ###########
 ## Step 3. Uses descriptive activity names for activities in the data set

 ## features.txt file location
 file <- "C:/Computer Tools/R_Language/JHopkins3_Clean_Data/Project/UCI HAR Dataset/features.txt"
 ## Note, set stringsAsFactors = FALSE otherwise strings show up as factors.
 col_names <- read.table(file, stringsAsFactors = FALSE)
 
 names_vector <- col_names[, 2] # Make a character vector for variables

 ## Now, insert header into tidy data frame
 names(tidy) <- names_vector

 ############## 
 ## Step 2. Extracts only the measurements on the mean and standard
 ## deviation for each measurement. 

 col_nums <- as.numeric()
 col_nums <- c(1:561)

 ## checking for "-mean()" and "-std()" in the header
 ## And also for "meanFreq()" because we have no choice at this
 ## point.  Variables containing "meanFreq()" will be removed later.
 ##
 ## IN grep: if value = FALSE, then a vector containing the integer
 ## index of the matches is returned. If TRUE, a vector containing
 ## the matching elements themselves is returned!

 ## Identify columns having -mean(), meanFreq() and std() values
 matches1 <- unique(grep("-mean()|-std()", names_vector, value=FALSE))

 ## Identify columns having meanFreq() values 
 matches2 <- unique(grep("-meanFreq()", names_vector, value=FALSE))

 ## Subtract matches2 from matches1.  These are the columns to keep
 matches3 <- setdiff(matches1, matches2)

 ## Subtract matches3 from all the columns in the data frame
 col_nums <- setdiff(col_nums, matches3)

 ## Delete the unwanted columns from the "tidy" data frame.
 tidy <- tidy[, -1*col_nums]  # Remove unwanted columns
 
 ################# Subjects - Volunteers ########################
 ## Step 4. Label the data set with descriptive variable names. 

 ## Read the data - train/subject_train.txt
 file <- "C:/Computer Tools/R_Language/JHopkins3_Clean_Data/Project/UCI HAR Dataset/train/subject_train.txt"
 sub <- read.table(file) # Note: "sub" is a data frame

 ## Read the test/subject_test.txt data & bind them to the subject train data
 file <- "C:/Computer Tools/R_Language/JHopkins3_Clean_Data/Project/UCI HAR Dataset/test/subject_test.txt"
 sub <- rbind(sub, read.table(file)) # Note: "sub" is a data frame

 names(sub) <- c("subject") 

 # cbind subjects (volunteers) to tidy data frame
 tidy <- cbind(tidy, sub)

 ########## Activity Labels #############################

 ## Read the data - train/y_train.txt
 file <- "C:/Computer Tools/R_Language/JHopkins3_Clean_Data/Project/UCI HAR Dataset/train/y_train.txt"
 act <- read.table(file) # Note: "act" is a data frame

 ## Read the test/y_test.txt data & bind them to the activity train data
 file <- "C:/Computer Tools/R_Language/JHopkins3_Clean_Data/Project/UCI HAR Dataset/test/y_test.txt"
 act <- rbind(act, read.table(file)) # Note: "act" is a data frame

 ## Read activity file
 file <- "C:/Computer Tools/R_Language/JHopkins3_Clean_Data/Project/UCI HAR Dataset/activity_labels.txt"
 act_labels <- read.table(file) # "act_labels" is a data frame - Used to read activities

 ## Loop and enter labels into the "tidy" data frame.

 activity <- character() # character vector for activity labels 

## For loop to replace Activity number with Activity label

 id <- 1:nrow(act)  # nrow(act) is the number of rows of tidy data
 
 for (i in id) {
    if (act[i, ]== 1) {lbl <- "WALKING"}
    if (act[i, ]== 2) {lbl <- "WALKING_UPSTAIRS"}
    if (act[i, ]== 3) {lbl <- "WALKING_DOWNSTAIRS"}
    if (act[i, ]== 4) {lbl <- "SITTING"}
    if (act[i, ]== 5) {lbl <- "STANDING"}
    if (act[i, ]== 6) {lbl <- "LAYING"}
    activity <- c(activity, lbl)
 }

 # cbind, Add Activity column to the "tidy" data frame
 tidy <- cbind(tidy, activity)

 ################# Create a second independent tidy data set ############
 ## Step 5. Create a second data set based on "tidy" 

 ## Calculate the average of each variable for each activity and 
 ## every volunteer (subject) using the aggregate function

 tidy_no2 <- aggregate(tidy[, 1:66], by=list(tidy$subject, tidy$activity), FUN = mean)

 ## Rename the two variables changed by aggregate.

 tidy_no2 <- rename(tidy_no2, replace=c("Group.1" = "subject", "Group.2" = "activity"))

 # Export tidy_no2 data frame as a text file using row.name=FALSE.

 write.table(tidy_no2, "tidy_no2.txt", row.name=FALSE) 


