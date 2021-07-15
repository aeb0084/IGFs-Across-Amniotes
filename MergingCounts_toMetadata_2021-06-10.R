### Use R to merge the counts data (From SamTools output) from each individual into a single file. 
## Have all of your *Counts.txt files in a single folder and set that folder as the working directory

getwd()
setwd("~/Box/SchwartzLab/Projects/TS_Lab_Lizard_IGFS/2019_Cross_Species_Expression/Data/RNAseq_Analysis/FinalData_Plots_BWA/AllCounts_Files_Merging")
rm(FinalData)
rm(IGF1.data)
rm(data)

# Make a list of file names for files that have .txt
filenames <- list.files(path = ".", pattern = "*.txt", all.files = FALSE, full.names = FALSE, recursive = FALSE, ignore.case = FALSE)

### Process the IGF1 Data
# Make a dataframe to hold the data parsed from each file
IGF1.data <- data.frame (Reference=NA, IGF1_length=NA, IGF1_counts=NA, IGF1_countsMultipleMap=NA, file=NA)
# for loop to take make a "data" file that contains columns "gene", "length", and count data for the first individual file name, then matching "gene" column keep adding the count data (column 3) for the next individuals
for (i in filenames)
{
  data <- read.table(i)
  {
  colnames(data)[c(1,2,3,4)] <- c("Reference","IGF1_length", "IGF1_counts", "IGF1_countsMultipleMap")
  data$file=i  #add column with final name
  IGF1.data <- merge(IGF1.data,data[1,], all.y=TRUE, all.x=TRUE)
  }
}
IGF1.data = subset(IGF1.data, select = c(1,2,3,4,5) )
Run<-sub('_Counts.txt','', IGF1.data$file)
IGF1.data<-cbind(IGF1.data, Run)
head(IGF1.data)

### Process the IGF2 Data
rm(data)
rm(IGF2.data)
IGF2.data <- data.frame (Reference=NA, IGF2_length=NA, IGF2_counts=NA, IGF2_countsMultipleMap=NA, file=NA)
# for loop to take make a "data" file that contains columns "gene", "length", and count data for the first individual file name, then matching "gene" column keep adding the count data (column 3) for the next individuals
for (i in filenames)
{
  data <- read.table(i)
  {
    colnames(data)[c(1,2,3,4)] <- c("Reference","IGF2_length", "IGF2_counts", "IGF2_countsMultipleMap")
    data$file=i  #add column with final name
    IGF2.data <- merge(IGF2.data,data[2,], all.y=TRUE, all.x=TRUE)
  }
}
head(IGF2.data)

Run<-sub('_Counts.txt','', IGF2.data$file)
IGF2.data<-cbind(IGF2.data, Run)
head(IGF2.data)
IGF2.data = subset(IGF2.data, select = c(2,3,4,6) )
head(IGF2.data)

### Pull out the Total library size
rm(data)
rm(LibSize.data)
LibSize.data <- data.frame (NA_Reference=NA, NAlength=NA, NAcounts=NA, LibSize=NA, file=NA)
# for loop to take make a "data" file that contains columns "gene", "length", and count data for the first individual file name, then matching "gene" column keep adding the count data (column 3) for the next individuals
for (i in filenames)
{
  data <- read.table(i)
  {
    colnames(data)[c(1,2,3,4)] <- c("NA_Reference","NA_length", "NA_counts", "LibSize")
    data$file=i  #add column with final name
    LibSize.data <- merge(LibSize.data,data[3,], all.y=TRUE, all.x=TRUE)
  }
}
head(LibSize.data)

Run<-sub('_Counts.txt','', LibSize.data$file)
LibSize.data<-cbind(LibSize.data, Run)
head(LibSize.data)
LibSize.data = subset(LibSize.data, select = c(2,8) )
head(LibSize.data)


#####  Merge the IGF1 and the IGF2 counts data to the Metadata
MetaData <- as.matrix(read.csv("TheBigTable-MetaData.csv"))
Data1 <- merge(IGF1.data,MetaData, by.x="Run", all.y=TRUE, all.x=TRUE)             
head(Data1)

Data2 <- merge(IGF2.data,Data1, by.x="Run", all.y=TRUE, all.x=TRUE)             
head(Data2)
                 
FinalData <- merge(LibSize.data, Data2,  by.x="Run", all.y=TRUE, all.x=TRUE)
head(FinalData) 

#######
# Normalize by reference gene length (in 1000bp)
FinalData$IGF1.RKGL= FinalData$IGF1_counts / (FinalData$IGF1_length / 1000)
FinalData$IGF2.RKGL= FinalData$IGF2_counts / (FinalData$IGF2_length / 1000)

# Relative proportions of IGF1 and IGF2 expression
FinalData$IGF1_Proportion= FinalData$IGF1.RKGL / (FinalData$IGF1.RKGL + FinalData$IGF2.RKGL)
FinalData$IGF2_Proportion= FinalData$IGF2.RKGL / (FinalData$IGF1.RKGL + FinalData$IGF2.RKGL)

head(FinalData)

#####
#write.csv(final.data, "combined.data.csv")
write.table (FinalData, file="MetaData_Counts.csv", row.names=FALSE, quote=FALSE,  sep=",")
 

