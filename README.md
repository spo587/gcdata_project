A guide to using run_analysis.R to produce two tidy data frames from the UCI HAR dataset.

The data in UCI HAR dataset displays physical measurements from accelerometers and gyroscopes on smart phones worn at the waist of 30 subjects performing 6 activities (with multiple samples of each activity).

The run_analysis.R script takes the data collected and returns two tidy data frames, initialTidyDF and meansOfSubjectActivityPairs.

The first data frame, tidyDFextractedRenamed, merges the test and training data from the UCI set, extracts the mean and standard deviation variables, adds two columns at the beginning for the activity label and subject, and renames the the column variables. This is a 10299 x 68 data frame, one column for the activity labels, one for subject, and 66 variables, with 10299 total observations.

The first data frame contains many observations of each of the variables for each given subject activity pair.
The second data frame, meansOfSubjectActivityPairs, takes mean value of each of the 66 variables from the initial data frame above, that is, one summary value of each variable for each subject activity pair. Thus it is a 180 x 67 data frame, with 180 columns for the 30 subjects * 6 activities, 1 column for the subject activity pair label, and 66 columns for the means of each of the variables.


Running run_analysis.R will put the two data frames in your R session, along with the many helper functions in the run_analysis.R script. For more information on the functions and variables, see the code book, CodeBook.md, or the script itself, which contains more detailed information for each step of the processing.



