library(dplyr)
library(datapkg)
library(RCurl)
library(httr)

##################################################################
#
# Processing Script for Pre-K Students - PSIS
# Created by Jenna Daly
# On 05/11/2017
#
##################################################################

#This data set is dependent on the Student Enrollment by Grade data set. 
#Student Enrollment should be updated before this data set can be updated. 

#Setup environment
sub_folders <- list.files()
data_location <- grep("raw", sub_folders, value=T)
path_to_raw_data <- (paste0(getwd(), "/", data_location))

# Read most recent student enrollment by grade file from GitHub:
url <- "https://raw.githubusercontent.com/CT-Data-Collaborative/student-enrollment-by-grade/master/data/student_enrollment_by_grade_2008-2021.csv"
path_to_student_enroll <- getURL(url)
student_enroll <- read.csv(text = path_to_student_enroll)

#Save student enrollment data set to raw folder
write.table(
  student_enroll,
  file.path(path_to_raw_data, "student_enrollment_by_grade_2008-2021.csv"),
  sep = ",",
  row.names = F
)

#Read in student enrollment, and isolate pre-k 
psis <- student_enroll[student_enroll$Grade == "Pre-Kindergarten",]

#Conform to PSIS settings
psis$Grade <- NULL
psis$Variable <- "Pre-K Students"
names(psis)[names(psis) == "Measure.Type"] <- "Measure Type"
psis$FIPS <- as.character(psis$FIPS)
psis[["FIPS"]][is.na(psis[["FIPS"]])] <- ""

#Write CSV
write.table(
  psis,
  file.path(getwd(), "data", "pre-k-students-psis_2008-2021.csv"),
  sep = ",",
  row.names = F
)

