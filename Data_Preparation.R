#################################################################################################
## OZKAN EMRE OZDEMIR                                                                           #
## HOMEWORK 4 : Data Preparation Assignment, Lecture # 5                                        #
## 08/10/16                                                                                     #
## Class:  Deriving Knowledge from Data at Scale                                                #
#################################################################################################
## 
## Consider the data collected by a hypothetical video store for 50 regular customers. 
## This data consists of a table which, for each customer, records the following attributes: 
## Gender 
## Income 
## Age 
## Rentals - Total number of video rentals in the past year 
## Avg. per visit - Average number of video rentals per visit during the past year 
## Incidentals - Whether the customer tends to buy incidental items such as refreshments when renting a video 
## Genre - The customer's preferred movie genre
##################################################################################################
## Clear objects from Memory :
rm(list=ls())
##Clear Console:
cat("\014")

## Set Working Directory
setwd('~/DataAtScale/class5')

##---- Load Libraries
install.packages("corrplot")
library(corrplot) #package corrplot
library(gmodels) #package for CrossTable
#################################################################################################
## Part A to E of this homework is performed using Azure ML and resulted dataset is 
## exported as "Assigment4.cvs"
#################################################################################################
##-----Load Data-----
data = read.csv('Video_Store.csv', stringsAsFactors = FALSE) #given dataset
data_prepped = read.csv('Assignment4.csv', stringsAsFactors = FALSE) #prepped dataset in Azure ML
head(data) #given data set
head(data_prepped) #prepped data set in Azure ML
#################################################################################################
## Part F : Correlation Matrix using prepped data
cross_tab_data <- data_prepped[-c(2,7,8)] # remove non-numerical columns
head(cross_tab_data)
corr_matrix<-cor(cross_tab_data)
corrplot(corr_matrix, method = "circle") #plot matrix
# The customer's "Age" and "Income" have the highest positive correlation;
# i.e. as the customers' income increases as they get older.
# Customer "Age" and "Rentals" have the highest negative correlation;
# i.e. as the customers gets older, the number of videos they rent decreases.
#################################################################################################
## Part G : Cross-tabulation "gender" and "genre" using given dataset
CrossTable(data$Gender,data$Genre,prop.t=FALSE,prop.chisq=FALSE)
# ?CrossTable
# Based on the tabulated results (below) following conclusions are made :
#       * More than half of the female customers (54.2 %) preferred  to rent "Drama" movies
#       * whereas, half of the male customers (50%) preferred  to rent "Action" movies
#       * 72.2 % of the "Action" movies were rented by male customers
#       * whereas, 65 % of the "Drama" movies were rented by female customers
#       * the total male and female customer numbers are almost equivalent  ( 48 % Female vs 52 % male)
#
#   Cell Contents
# |-------------------------|
# |                       N |
# |           N / Row Total |
# |           N / Col Total |
# |-------------------------|
#  
# Total Observations in Table:  50 
#  
#              | data$Genre 
#  data$Gender |    Action |    Comedy |     Drama | Row Total | 
# -------------|-----------|-----------|-----------|-----------|
#            F |         5 |         6 |        13 |        24 | 
#              |     0.208 |     0.250 |     0.542 |     0.480 | 
#              |     0.278 |     0.500 |     0.650 |           | 
# -------------|-----------|-----------|-----------|-----------|
#            M |        13 |         6 |         7 |        26 | 
#              |     0.500 |     0.231 |     0.269 |     0.520 | 
#              |     0.722 |     0.500 |     0.350 |           | 
# -------------|-----------|-----------|-----------|-----------|
# Column Total |        18 |        12 |        20 |        50 | 
#              |     0.360 |     0.240 |     0.400 |           | 
# -------------|-----------|-----------|-----------|-----------|
#
#################################################################################################
## Part H :  Find "good" custormers. i.e. "Rentals" => 30 using given dataset
good_customers<-data[data$Rentals>=30,]
summary(good_customers)
#bar plots
barplots <- function(data_name){
        barplot(table(data_name$Gender),xlab="Gender",ylab="freq.")
        barplot(table(data_name$Income),xlab="Income",ylab="freq.")
        barplot(table(data_name$Age),xlab="Age",ylab="freq.")
        barplot(table(data_name$Rentals),xlab="Rentals",ylab="freq.")
        barplot(table(data_name$Avg.Per.Visit),xlab="Avg.Per.Visit",ylab="freq.")
        barplot(table(data_name$Incidentals),xlab="Incidentals",ylab="freq.")
        barplot(table(data_name$Genre),xlab="Genre",ylab="freq.")
        
}

barplots(good_customers)

# Based on the given criteria, the "good" customer whose rents more than 30 movies in a year
# whose average salary is around "$30k" or higher
# he/she is in his/her "mid 20s"
# visits to the store around "2 to 3" times a year or more 
# and his/her preference is to rent "Action" movies
# can be a "Female" or "Male"

## The most clear conclusion was a good customer rents most likely an action movie (bar plots).
## Let's compare the action movie renters profile and see if this conclusion is accurate

action_customers<-data[data$Genre== "Action",]
summary(action_customers)
#bar plots
barplots(action_customers)

# When we compared the summary of the two dataset, "Action" movie renter profile and
# good customer profile, they agreed well. Since an "Action" movie renter customer;
# has an average salary is around "$32k" or higher
# in his mid 20s
# rents more than 30 movies in a year
# visits the store around "2 to 3" times a year or more
# One important outcome for this comparision was, a good customer who rents Action movies
# most likely is a "Male" customer (bar plot)
# and will purchase other "incidentals" (bar plot)
#################################################################################################
# Part I : Identify the target custumer profile who doesn't purchase incidentals
# Finally, let's look at the cutomers who doesnt purchase incidentals:
unincidental_customers<-data[data$Incidentals!= "Yes",]
summary(unincidental_customers)
# bar plots
barplots(unincidental_customers)
# Based on the summary of the dataset and the bar plots a customer whose less likely to purchase incidentals
# has an average salary is around "$40k"
# in early to late 20s (bar plot)
# rents more than 20 movies in a year
# visits the store around "2 to 3" times a year or more
# prefers to watch "Comedy" or "Drama" instead of "Action" movies
# Another important outcome for this analysis is that a customer who doesn't purchase incidentals
# is most likely is a "Female" customer (bar plot)
#################################################################################################
## END