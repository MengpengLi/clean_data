library(plyr)

#reading data from files, and name the variables at the same time from features
features <- read.table("//Users/Angrybirdy/Documents/data_science/UCI HAR Dataset/features.txt")
featuresSet <- as.vector(features[,2])  
TestY <- read.table("//Users/Angrybirdy/Documents/data_science/UCI HAR Dataset/test/Y_test.txt",col.names = "Y",colClasses = "numeric")
TrainY <- read.table("//Users/Angrybirdy/Documents/data_science/UCI HAR Dataset/train/Y_train.txt",col.names = "Y",colClasses = "numeric")
TestSub <- read.table("//Users/Angrybirdy/Documents/data_science/UCI HAR Dataset/test/subject_test.txt",col.names = "sub",colClasses = "numeric")
TrainSub <- read.table("//Users/Angrybirdy/Documents/data_science/UCI HAR Dataset/train/subject_train.txt",col.names = "sub",colClasses = "numeric")
TrainSet <- read.table("/Users/Angrybirdy/Documents/data_science/UCI HAR Dataset/train/X_train.txt",col.names = featuresSet,colClasses = "numeric")
TestSet <- read.table("/Users/Angrybirdy/Documents/data_science/UCI HAR Dataset/test/X_test.txt", col.names = featuresSet,colClasses = "numeric")

#merging data
TestData <- cbind(TestSub,TestY)
TestData <- cbind(TestData,TestSet)
TrainData <- cbind(TrainSub,TrainY)
TrainData <- cbind(TrainData,TrainSet)
DataSet <- rbind(TrainData,TestData)

#only first two and selected columns which contains mean() or std() left
shortList <- DataSet[,c(1,2,grep(pattern = "mean()|std()",colnames(DataSet)))] 
aLabel <- read.table("/Users/Angrybirdy/Documents/data_science/UCI HAR Dataset/activity_labels.txt")

#assign the name for activities numbers
shortList$Y <- aLabel$V2[shortList$Y]

#generating the second list which contains the average for each variables depends on the subject and activities
TidyData <- data.frame()
for(i in 1:30){
      n = 1
      for(j in aLabel$V2){
            temp <- shortList[as.numeric(shortList$sub) == i,]
            temp <- temp[temp$Y == j,]
            temp2 <- data.frame(t(data.frame(colMeans(temp[,3:81]))))
            temp3 <- cbind(temp[1,1:2],temp2)
            TidyData <- rbind(TidyData,temp3)
      }
}
colnames(TidyData)[2] <- "activity"
write.table(TidyData,"tidy.txt", row.names = FALSE)
