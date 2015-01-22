A guide to using run_analysis.R to clean and process the data on smartphone movement

THE DATA

The data is all stored in the directory UCI HAR Dataset, with further paths to the data described below.
test/X_test.txt : The test data, with the measurements of the smartphone variables as different columns. Each row corresponds to a sample for a single subject and activity. The labels for these variables are not in this set, but rather are in the following two files.
test/subject_test.txt: A single column text file containing the subject labels for the rows in the X_test file above
test/y_test.txt: A single column text file containing the activity labels for the rows in the X_test file above.


train/X_train.txt: just like X_test.txt but for the training data.
train/subject_train.txt: just like subject_test.txt but for the training data.
train/y_train.txt: just like y_test.txt, but for the subject_data.

features.txt: a two column text file, with the second column giving the variable names that correspond to the rows of the X_test.txt and X_train.txt files above (the first column is just numerical labels.)

activity_labels.txt: a 6 row text file for converting the y_test and y_train activity labels (integers 1-6) to their corresponding activities (walking, walking upstairs, etc.)


FUNCTIONS AND VARIABLES IN RUN_ANALYSIS.R
contents:
I.
1. Helper functions for importing the data from the text files.
2. Functions for finding the relevant data and renaming the columns/activity variables
3. Functions for merging the test and train data
4. Two functions to take the actual data files and return a clean, tidy data frame, stored in the variable initialTidyDF

II.
5. functions for melting the tidy data set created in part I and finding the means of the relevant variables
6. Function for recasting the melted data frame into a wide data frame, and 
7. function to perform steps 5 and 6 in one step, and a variable to store final wide frame (meansOfSubjectActivityPairs)


I.
1. Helper functions for importing data from txt files:

dfFromFile(tableFile) : takes a txt file with a table and returns a data frame. Will use this function on the the test/X_test.txt and train/X_train.txt files. 

labelVector(oneColumnFile, colNumber) : takes a text file that only has one relevant column, an independent variable, and returns a vector with the data. The test/y_test.txt and train/y_train.txt files have the activity labels for each of the rows in the test and training data respectively, and are in this format. As are the train/subject_train.txt and train/subject_train.txt files.

prepareDF(tableFile, activityFile, subjectFile) : takes a tablefile (either the test or train data), along with the corersponding
activities and subject file and returns a single data frame with the activity label in the first column and the subject in the second, with all the other variables in the remaining columns




2. Functions for finding the relevant data and renaming the columns/activity variables:

findRelevantCols(featureLabelFile) : takes the features.txt file as input and finds all the variables with mean() and std() in them, returns a vector with the relevant indices.

getPreliminaryColNames(featureLabelFile) : takes the same input, returns a vector with the names of the relevant variables from the features.txt file.

extractRelevantCols(df, featureLabelFile): takes a data frame from prepareDF and the features.txt file and returns a data frame only with the relevant columns returned from findRelevantCols

renameVariablesPreliminary(df, featureLabelFile): takes a data frame from the above function and adds relevant column names from extractRelevantCols, returns that data frame.

renameActivityVariables(df) : takes a data frame from the above function and relabels all the activites 1 -> walking, 2 -> walking upstairs, etc.

renameColNames(vec) : takes only a vector of column names, from the names of a data frame returned by one of the above functions, and returns a vector with the mean and std variables renamed in more readable english (the first two entries of the vector, for the activity and subject labels, stay the same).

renameVariables(df) : takes a data frame returned from renameActivityVariables or renameVariablesPreliminary and renames the 3rd through end column variables using renameColNames.




3. Functions for merging the test and train data:

merge(df1, df2) : takes two data frames, returns a single one, a vertical merge of the two using merge function

boundData(df1, df2): essentially the same, but the output is slightly different, using rbind instead of merge




4. Two functions to take the actual data and return a tidy data frame:

prepareTestAndTrainDataAndMerge() : no inputs, just outputs the merged data from the training set and test set, with the label columns from the y_test and y_train and subject_test and subject_train files added, but without any columns or labels renamed

makeTidyAndLabeledDataFrame() : uses all of the above functions to perform step 4 of the assignment in one step, returns a data frame with only the relevant variables, relabeled, and with the activities renamed as well. 

Using the above function, we have a variable that stores the tidy data frame:

initialTidyDF <- makeTidyAndLabeledDataFrame()




II.
5. functions for melting the tidy data set created in part I and finding the means of the relevant variables

meltAndFindMeans(df) : takes a data frame created in step 4 above, melts it into narrow form and creates a new variable with the means of all activity subject pairs. Returns a data frame that is then 11880 x 4 (11880 = 30 subjects * 6 activities * 66 variables)

combineActivitySubjectCols(moltendf) : takes a data frame returned by meltAndFindMeans above and combines the first two columns (activity label and subject label) into one column for clarity, so each entry is a single activity subject pair, returns this data frame now with only 3 columns (activitySubjectPair, variable, and means)



6. function to recast the above into a wide data frame

recastDF(moltenDF) : takes a molten data frame returned by combineActivitySubjectCols above and recasts it as a wide data frame with each subject activity pair as a single row, with each variable's mean in the columns. so it returns a 180 x 66 data frame



7. function to do assignment prompt 5 all in a single step, from data frame in step 4

newTidyDataSetWithMeansWide(df) : takes a data frame from I. 4 above and applies functions from II. 5 and II. 6 above to return a single wide, tidy data frame with the first column renamed to 'activity/subject pairs'.

meansOfSubjectActivityPairs stores this wide data frame in a variable.



