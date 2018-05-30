#Download and unzip the file 

if(!file.exists("./projectData")){
  dir.create("./projectData")
}
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("./projectData/project_Dataset.zip")){
  download.file(Url,destfile="./projectData/project_Dataset.zip",mode = "wb")
}


if(!file.exists("./projectData/UCI HAR Dataset")){
  unzip(zipfile="./projectData/project_Dataset.zip",exdir="./projectData")
}

#see all the files in the unzipped folder 
path <- file.path("./projectData" , "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)
files


#Read files to R 

ActivityTest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)


SubjectTrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
SubjectTest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)


FeaturesTest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)



#Merge the test and train datasets 
dataSubject <- rbind(SubjectTrain, SubjectTest)
dataActivity<- rbind(ActivityTrain, ActivityTest)
dataFeatures<- rbind(FeaturesTrain, FeaturesTest)

#Giving names to the variables 
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

#Combine the data

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)



#extract measurements with mean and standard deviation 


subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

View(subdataFeaturesNames)
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)

Data$activity<-factor(Data$activity,labels=activityLabels[,2])
View(Data)


#Appropriately labels the data set with descriptive variable names.


names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))


names(Data)


#Create a New Tidy data

newData<-aggregate(. ~subject + activity, Data, mean)
newData<-newData[order(newData$subject,newData$activity),]
write.table(newData, file = "tidydata.txt",row.name=FALSE,quote = FALSE, sep = '\t')


