
```{r}
library(plyr)
library(dplyr)
```

```{r}
setwd("C:/Users/User/Desktop/Cor3") #Location of files
y.test<-read.table("y_test.txt") #Load in the response for the test data dim is 2946 x 1
y.train<-read.table("y_train.txt") #Load in the response for the train data, dim is 7352 x 1
  
x.test<-read.table("X_test.txt") #Load in the predictors for the test data. dim is 2946 x 561
x.train<-read.table("X_train.txt") #Load in the predictors for the train data. dim is 7352 x 561
  
sub.test<-read.table("subject_train.txt") #Load in the subj information for the test data. dim is 7351 x 1
sub.train<-read.table("subject_test.txt") #Load in the subj information for the train data dim is 2946 x 1
features<-read.delim("features.txt",sep="-") #load in the feature infomation, dim is 560 x 1
activity.label<- read.table("activity_labels.txt") # dim is 6x2
```

```{r}
x.full<-rbind(x.train,x.test)
y.full<-rbind(y.train,y.test)
sub.full<-rbind(sub.test,sub.train)
```

```{r}
#For each measurment, we only want those contiang mean or std, use grep on the features data set
colnames(features)=c("Y","ft","dir")
 #smean<-grep("^mean",features$ft) #Select the rows containing mean
 #sstd<-grep("^std",features$ft) #Select the rows containing std
smean<-which(features$ft=="mean()")
sstd<-which(features$ft=="std()")
 
 mer<-c(smean,sstd) #Rows containing either mean or sd.
 
 features.sub<-features[mer, ]
x.full<-x.full[ ,mer] #Since the rows of features correspond to columns of X , only keep those columns of x which appeared in mer.
```

```{r}
colnames(y.full)="ActivityLevel"
y.full$label=factor(y.full$ActivityLevel,labels=as.character(activity.label[,2]))
colnames(x.full)=features.sub[ ,1]
colnames(sub.full)<-"Subject"
```

```{r}
#Form the new tidy data set, bring in appropriate labels.
ActivityLevel=y.full[,2]
full_data<-cbind(x.full,y.full)
full.mean=full_data %>%
  group_by(label) %>%
  summarize_each(funs(mean))
write.table(full.mean,file="ftidy.txt",col.names = FALSE,row.names=FALSE)
full_data=cbind(x.full,ActivityLevel,sub.full)
full.mean <- full_data %>% group_by(ActivityLevel,Subject) %>% summarize_each(funs(mean))
write.table(full.mean,file="ftidy.txt",col.names = TRUE,row.names = FALSE)
setwd("C:/Users/User/Desktop/Cor3") #Location of files
tidyTable<-read.table("ftidy.txt")
