# This script expects the input dataset to be expanded and in the current working directory
# The dataset should be in the the "UCI HAR Dataset/" directory, i.e. as expanded from its
# gzip archive.
 
# TODO specify the home directory here
setwd("/Users/Shared/projects/coursera/getting-cleaning-data/project")

# load in the measured values
x_train <- read.table("./UCI\ HAR\ Dataset/train/X_train.txt", header=FALSE)
x_test <- read.table("./UCI\ HAR\ Dataset/test/X_test.txt", header=FALSE)

# let's just combine them now - keeps things simpler. and I have memory for it 
# remember that we do them alphabetically - thus 'test' before 'train'
allxdata <- rbind(x_test,x_train)

# how to find the 'mean' and 'std' cols?
# the features table has a row number and a name with these in it, so start there
features <- read.table("./UCI\ HAR\ Dataset/features.txt", stringsAsFactors=FALSE)

# add the names for all columns
names(alldata) <- features$V2

# which columns match the criteria? they all seem to have -mean or -std
# there are some angles of means which do not appear to be what we're looking for
meanstd <- features[grep("-mean|std",features$V2,ignore.case=TRUE),]

# to get the columns we want, use the first frame column which has the index
meanstddata <- allxdata[,meanstd$V1]

#dim(meanstddata)
# at this point we have the "raw" mean/std data for all subjects separated out.
# now we need to get the activities and subjects.
# start with activities

# in both train/ and test/ there is a y_<name>.txt which appear to be the activity labels
# associated with each row of the data in that directory. 

y_test <- read.table("./UCI\ HAR\ Dataset/test/y_test.txt", header=FALSE)
y_train <- read.table("./UCI\ HAR\ Dataset/train/y_train.txt", header=FALSE)

# remember to bind them in alpha order:
allydata <- rbind(y_test,y_train)

# we have to name them as well. that's going to require a join/merge, let's try it now
# by giving them each the same column-name and joining them on that common name
# don't want it sorted, since we still need to apply it to the main table
activity_labels <- read.table("./UCI\ HAR\ Dataset/activity_labels.txt", header=FALSE)
names(activity_labels) <- c("label","name")
names(allydata) <- "label"
# apparently merge has the side-effect of sorting on the 'by=' variable
# its not documented in 'merge' but it is in 'join':
# "Unlike merge, preserves the order of x no matter what join type is used."
#ydata_activity_names <- merge(allydata, activity_labels)
ydata_activity_names <- join(allydata, activity_labels,by=c("label")

# are these things really in this order? ydata is only values 1-6 so they must be activity indices
meanstddata$activity <- ydata_activity_names$name

# now let's look at the subjects
subject_test <- read.table("./UCI\ HAR\ Dataset/test/subject_test.txt", header=FALSE)
subject_train <- read.table("./UCI\ HAR\ Dataset/train/subject_train.txt", header=FALSE)

# put them together in the correct order
allsubjects <- rbind(subject_test,subject_train)

# confirm, this is a frame with 1 column, the subject index, values 1-30
# let's add it to the rest of the data
meanstddata$subject <- allsubjects[,1]

# I thought aggregate was going to do this, but now i'm not so sure. when I try this
# t1 <- aggregate(meanstddata,by=list(meanstddata$subject,meanstddata$activity), FUN=mean)
# I find that the number of activities seems to be limited - there are no longer 6 activities
# per subject. Were there to begin with? Look at this:
# t3 <- meanstddata[order(meanstddata$subject,meanstddata$activity),]
#answer is no. Now is this because of a mistake on my part or is the data wrong?
# mistake on my part - 'merge' reorders the data.
# use this to check:
# unique(meanstddata[meanstddata$subject == 1, c("activity")])

# use reshape2, it seems to be easier
require("reshape2")
m1 <- melt(meanstddata,id.vars=c("subject","activity"),measure.vars=1:79)
r1 <- dcast(m1, subject + activity ~ variable, fun.aggregate=mean)

# and there's the final data we want. now we need to clean up the names
# and provide some codebook 
# this is just going to be 'brute force' teasing apart each element in turn
# first separate out the name components
f1 <- gsub("^(t|f)(.*)-(mean|std)(.*)\\(\\)(-?)(X|Y|Z)?", "\\1 \\2 \\3 \\4 \\6", names(r1))
# now factor out each component in term, starting from the end and working backwards
f2 <- gsub("Mag", " Magnitude", f1)
f3 <- gsub("Jerk", " Jerk", f2)
f4 <- gsub("Gyro", " Gyro", f3)
f5 <- gsub("Acc", " Acceleration", f4)
f6 <- gsub("^f","FFT", f5)
f7 <- gsub("^t", "Time", f6)

# okay, we have it let's call it good:
tidydata <- r1
names(tidydata) <- f7

# save it
write.csv(tidydata,"tidydata.csv",row.names=FALSE)
