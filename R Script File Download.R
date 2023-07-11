## ************************* DATA SCRAPING **************************

library(rvest)
library(dplyr)
base_url <- "https://www.seek.com.au/data-scientist-jobs"

# Create an empty list to store the job details
job_details <- list()

# Create empty lists to store the job details
job_titles <- list()
industries <- list()
states <- list()
salaries <- list()
date_times <- list()

# Loop through each page of search results
for (page in seq(from = 1, to = 25)) {
  # Create the complete URL for the current page
  url <- paste0(base_url, "?page=", page)
  webpage <- read_html(url)
  
  # Extracting job containers
  job_containers <- html_nodes(webpage, "article[data-automation='normalJob']")
  
  # Extract job details from each container
  for (container in job_containers) {
    job_title <- html_text(html_nodes(container, "a[data-automation='jobTitle']"))
    industry <- html_text(html_nodes(container, "a[data-automation='jobClassification']"))
    state <- html_text(html_nodes(container, "a[data-automation='jobLocation']"))
    salary <- html_text(html_nodes(container, "span[data-automation='jobSalary']"))
    date_time <- html_text(html_nodes(container, "span[data-automation='jobListingDate']"))
    # Convert the result into a single value
    state <- paste(state, collapse = " ")
    print(state)
    if(length(job_title) == 0){
      job_titles <- append(job_titles, NA)
    }else{
      job_titles <- append(job_titles, job_title)
    }
    
    if(length(industry) == 0){
      industries <- append(industries, NA)
    }else{
      industries <- append(industries, industry)
    }
    
    if(length(state) == 0){
      states <- append(states, NA)
    }else{
      states <- append(states, state)
    }
    
    if(length(salary) == 0){
      salaries <- append(salaries, NA)
    }else{
      salaries <- append(salaries, salary)
    }
    
    if(length(date_time) == 0){
      date_times <- append(date_times, NA)
    }else{
      date_times <- append(date_times, date_time)
    }
  }
}


# Create a data frame from the extracted job details
Job_Title = unlist(job_titles)
Industry = unlist(industries)
State = unlist(states)
Salary = unlist(salaries)
Date = unlist(date_times)

final_data <- as.data.frame(cbind(Job_Title, Industry, State, Salary, Date))

saveRDS(final_data, "final_data.rds")
write.csv(final_data, "final_data.csv")


#### ************************ Data Cleaning ************************



library(stringr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(lubridate)


# Extracting only 2 characters or 3 characters state
final_data$State <- str_extract(final_data$State, "\\b\\w{2,3}\\b")

# Extract only first portion of salaries
final_data$SalaryCleaned <- str_extract(final_data$Salary, "\\$\\S+[-\\s]")

# Function to check if salary posted is per day or per anum
get_value <- function(string) {
  if (grepl("day|p.d|p.d.", string, ignore.case = TRUE))
    return("PerDay")
  if (grepl("annum|year", string, ignore.case = TRUE))
    return("PerYear")
  return(NA)
}

# Apply the function to create the new column which represents whether salary is per anum or per day.
final_data$SalaryUnit <- sapply(final_data$Salary, get_value)

# Function to check if salary is in K or not.
get_value2 <- function(string) {
  if (grepl("k", string, ignore.case = TRUE))
    return("Yes")
  else
    return("No")
}

# Apply function to create new column which represents that whether salary should be multiplied by 1000 or not.
final_data$Units <- sapply(final_data$Salary, get_value2)

# Divide salary column based on - as for some salaries we have a range so only first value is used here.
final_data <- separate(final_data, SalaryCleaned, into = c("SalaryCleaned", "Extra"), sep = "-")

# Remove special characters from salary column.
final_data$SalaryCleaned <- gsub("\\$", "", final_data$SalaryCleaned)
final_data$SalaryCleaned <- gsub("\\,", "", final_data$SalaryCleaned)
final_data$SalaryCleaned <- gsub("\\+", "", final_data$SalaryCleaned)
final_data$SalaryCleaned <- gsub("\\k", "", final_data$SalaryCleaned)
final_data$SalaryCleaned <- gsub("\\K", "", final_data$SalaryCleaned)
final_data$SalaryCleaned <- gsub("\\hr", "", final_data$SalaryCleaned)
final_data$SalaryCleaned <- gsub("\\/", "", final_data$SalaryCleaned)
final_data$SalaryCleaned <- gsub(" ", "", final_data$SalaryCleaned)
final_data$SalaryCleaned <- as.numeric(final_data$SalaryCleaned)

# Multiply salary by 1000 if it is in K units.
final_data$SalaryCleaned <- ifelse(final_data$Units == "Yes", 
                                   final_data$SalaryCleaned * 1000, 
                                   final_data$SalaryCleaned)

# Taking 22 working days and calculating salary for those where salary is per day
final_data$SalaryCleaned <- ifelse(final_data$SalaryUnit == "PerDay", 
                                   final_data$SalaryCleaned * 22 * 12, 
                                   final_data$SalaryCleaned)

# Removing outliers from salary column
Q1 <- quantile(final_data$SalaryCleaned, .25, na.rm = T)
Q3 <- quantile(final_data$SalaryCleaned, .75, na.rm = T)
IQR <- IQR(final_data$SalaryCleaned, na.rm = T)

#only keep rows in dataframe that have values within 1.5*IQR of Q1 and Q3
no_outliers <- subset(final_data, 
                      final_data$SalaryCleaned > (Q1 - 1.5*IQR) & 
                        final_data$SalaryCleaned < (Q3 + 1.5*IQR))


# Converting to numeric, calculating date of posting and removing irrelevant info.

final_data$Date <- gsub("d ago", "", final_data$Date)
final_data$Date <- as.numeric(final_data$Date)
final_data$JobDate <- Sys.Date() - days(final_data$Date)
final_data$JobDate[is.na(final_data$JobDate)] <- Sys.Date()

# Adding day of week column
final_data$weekday <- lubridate::wday(final_data$JobDate)


saveRDS(final_data, "Cleaned_Data.rds")
write.csv(final_data, "Cleaned_Data.csv")
write.csv(no_outliers, "SalaryCleaned.csv")

