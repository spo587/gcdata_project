## Hi! Here's the structure of this script.
## I. In the first part, we're getting the data ready for prompt 4 from the assignment.
## 1. helper functions for loading the txt files, making sure 
## we have the right rows and columns.
## 2. Some functions for renaming the columns and the activities
## 3. Helper functions for the merge.
## 4. Functions for actually loading the data from the text files, 
## and finally one that uses all of the above functions to produce
## our tidy data frame (for prompt 4 of assignment) in fell swoop.

## II. In part II, we deal with prompt 5.
## 5. melt the data frame from prompt 4, above and find the means of each subject x activity pair
## 6. recast into a wide data frame with one observation per row and one variable per column
## 7. Combine into a single step.

## Okay, here we go. I. 1

## extract a data frame from a table in text file format
dfFromFile <- function(tableFile){
    table <- read.table(tableFile)
    table
}

## extract a vector from a txt file that only has one relevant column,
## an independent variable, such as the subjects file.

labelVector <- function(oneColumnFile, colNumber){
    labelAsDF <- read.table(oneColumnFile)
    labelVector <- as.vector(labelAsDF[,colNumber])
    labelVector
}

## add the relevant columns (independent variables, activity and subject number)
## from one of the single column txt files
## as the first column of a data frame (dependent variables only) 
## from one of the other text files. Returns a data frame
## with independent variables as the first columns
prepareDF <- function(tableFile, activityFile, subjectFile){
    variableDF <- dfFromFile(tableFile)
    activityVec <- labelVector(activityFile,1)
    subjectVec <- labelVector(subjectFile,1)
    fullDF <- cbind(activityVec, subjectVec, variableDF)
    fullDF
}


## find the relevant features (ie, the ones with means
## and standard deviations). Returns a vector with the 
## indices of those features in the features.txt column vector
findRelevantCols <- function(featureLabelFile){
    featureLabelsVec <- labelVector(featureLabelFile,2) # 2nd column since this
    ## file has a column simply of numbers as its first column
    ## find means
    mean_cols <-  which(grepl('mean\\(\\)', featureLabelsVec))
    ## find stds
    std_cols <- which(grepl('std', featureLabelsVec))
    means_and_stds <- append(mean_cols, std_cols)
    means_and_stds
}

## the next function finds the original names of these variables
## and stores them separately in a vector
getPreliminaryColNames <- function(featureLabelFile){
    cols <- findRelevantCols(featureLabelFile)
    featureLabelsVec[cols] 
}

## this function combines the function extracts the relevant columns
## found using the findRelevantCols function above from
## one of the data frames
extractRelevantCols <- function(dataFrame, featureLabelFile){
    cols <- findRelevantCols(featureLabelFile)
    ## we need the first two indep. variable columns we added,
    ## and the remaining columns stored in the cols variable above,
    ## only moved over by 2 since they are displaced by that much
    ## in our data frame
    colsNeeded <- append(c(1,2), cols + 2)
    extractedDataFrame <- dataFrame[,colsNeeded]
    extractedDataFrame
}

## I. 2
## after we extract the relevant columns, we can rename the variables,
## using get preliminaryColNames above and adding the common sense 
## names for the first two columns
renameVariablesPreliminary <- function(dataFrame, featureLabelFile){
    names(dataFrame) <- c('activity label','subject number', 
                          getPreliminaryColNames(featureLabelFile))
    dataFrame
}

## this function renames the activities back to their
## real world names from their numbers 1:6 and converts them to factors
renameActivityVariables <- function(df){
    df$'activity label' <- cut(df$'activity label', 
                               breaks=6, labels=c('walking', 
                                                  'walking upstairs', 
                                                  'walking downstairs', 
                                                  'sitting', 'standing', 
                                                  'lying down'))
    df
}


## this function takes the column of cryptic variable names
## and replaces them with something english and readable, though also
## much longer and more annoying

renameColNames <- function(vec) {
    for(i in 3:length(vec)){
        first <- ifelse(substr(vec[i],1,1) == 't','time domain','frequency domain')
        second <- ifelse(substr(vec[i],2,5) == 'Body',' body',' gravity')
        third <- ifelse(grepl('Acc',vec[i]), ' linear acceleration',' angular (gyroscope) acceleration')
        fourth <- ifelse(grepl('Jerk', vec[i]),' jerk signal',' signal')
        fifth <- ifelse(grepl('X', vec[i]),' along the x axis','')
        sixth <- ifelse(grepl('Y', vec[i]),' along the y axis','')
        seventh <- ifelse(grepl('Z', vec[i]),' along the z axis','')
        eighth <- ifelse(grepl('Mag', vec[i]),' magnitude of','')
        ninth <- ifelse(grepl('mean', vec[i]), ' mean of',' standard deviation of')
        vec[i] <- paste(first,ninth,eighth, second,third,fourth,fifth,sixth,seventh, sep='')
    }
    vec
}

## this function will use the above one to actually rename the (3rd through last) columns of
## our test/train combined data frame.
renameVariables <- function(df){
    names <- names(df)
    names(df) <- renameColNames(names)
    df
}

# I. 3
## helper functions for merging data

## a vertical merge
mergeData <- function(df1, df2){
    merged <- merge(df1, df2, all=TRUE)
    merged
}

## achieves the same thing as merge above but leaves rows of data in different order
## than merge. no real reason to include both, but thought I might as well include,
## since I tested each of them!

boundData <- function(df1, df2){
    bound <- rbind(df1, df2)
    bound
}

# I. 4
## okay, enough helper functions. time to process the data.

## this function gives us our big data frame, combining
## the test and train data sets and extracting relevant columns, 
##  but without renaming anything yet.
prepareTestAndTrainDataAndMerge <- function(){
    testData <- prepareDF('UCI HAR Dataset/test/X_test.txt','UCI HAR Dataset/test/y_test.txt', 'UCI HAR Dataset/test/subject_test.txt')
    trainData <- prepareDF('UCI HAR Dataset/train/X_train.txt', 'UCI HAR Dataset/train/y_train.txt', 'UCI HAR Dataset/train/subject_train.txt')
    ##merged <- boundData(testData, trainData)
    ## alternate
    merged <- mergeData(testData, trainData)
    mergedExtracted <- extractRelevantCols(merged, 'UCI HAR Dataset/features.txt')
    
}


## combine everything to do prompt 4 in one step:
## Returns a data frame with descriptive names of the relevant variables and of the
## activities by first merging and extracting, then renaming stuff.

makeTidyAndLabeledDataFrame <- function(){
    mergedExtracted <- prepareTestAndTrainDataAndMerge()
    firstColsRenamed <- renameVariablesPreliminary(mergedExtracted, 'UCI HAR Dataset/features.txt')
    activitiesRenamed <- renameActivityVariables(firstColsRenamed)
    measureVariablesRenamed <- renameVariables(activitiesRenamed)
    measureVariablesRenamed
}


## we can store our processed data frame in the variable below

initialTidyDF <- makeTidyAndLabeledDataFrame()


## II. 5
## and on to part 2, dealing with prompt 5.

## this function below returns a molten (narrow) data frame with the means
## of each of the 66 variables we already extracted for each activity x subject
## pair.

meltAndFindMeans <- function(df){
    melted <- melt(df, id.vars=c(names(df)[1], names(df)[2]))
    means <- ddply(melted, c(1,2,3), summarise,
                   mean = mean(value))
    means
}

## Just for added clarity, combine the first two columns of our molten data frame
## into a single one, so that when we recast, each row will be different measurement 
## (the first column of each row will be a single different activity subject pair)

combineActivitySubjectCols <- function(moltendf){
    activitySubjectPairs <- paste(moltendf$'activity label', 
                                      moltendf$'subject number')
    newdfCombined <- cbind(activitySubjectPairs, moltendf)
    newdfCombined[,c(1,4,5)]
}

# II. 6
## finally, for readability, a function
## to recast our molten data frame back to wide format,
## leaving us with a nice, clean, tidy data frame with one activity subject pair
## per row and one variable mean per column. 

recastDF <- function(moltendf) {
    recast <- dcast(moltendf, moltendf$activitySubjectPairs ~ moltendf$variable)
    recast
}

# II. 7

## this achieves step 5 all in one step, with the input df a data frame
## returned from prompt 4. Alternatively, uncomment the first line and 
## take out the function parameter to do step 5 all in one step.
newTidyDataSetWithMeansWide <- function(df){
    #df <- makeTidyAndLabeledDataFrame()
    meansNarrow <- meltAndFindMeans(df)
    relabeled <- combineActivitySubjectCols(meansNarrow)
    wide <- recastDF(relabeled)
    # rename the first column nicely
    names(wide)[1] <- 'activity/subject pairs'
    wide
}

## finally, let's store our means data frame in a variable 

meansOfSubjectActivityPairs <- newTidyDataSetWithMeansWide(initialTidyDF)



