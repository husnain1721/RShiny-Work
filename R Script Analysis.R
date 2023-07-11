## ****************************** DATA ANALYSIS ************************

final_data <- read.csv("Cleaned_Data.csv")

# Number of positions by state
positionsByState <- final_data %>%
  group_by(State) %>%
  summarise(Positions = n()) %>%
  arrange(-Positions)

# Plotting number of positions posted by state
ggplot(data = positionsByState, 
       mapping = aes(x = State, 
                     y = Positions, 
                     fill = State)) +
  geom_bar(stat="identity", position = "dodge") +
  labs(title = "Number of Positions By State") + 
  theme(axis.text.x = element_text(angle=45, hjust=1))


# Create a histogram of the "Salary" column to show its distribution
ggplot(data = no_outliers, 
       aes(x = SalaryCleaned)) +
  geom_histogram(binwidth = 10000, 
                 fill = "steelblue", 
                 color = "orange") +
  labs(x = "Salary", 
       y = "Frequency", 
       title = "Salary Distribution")

# Creating a table to show summary of salary by state
salaryByState <- no_outliers %>%
  group_by(State) %>%
  summarise(Mean = mean(SalaryCleaned, na.rm = T),
            Min = min(SalaryCleaned, na.rm = T),
            Max = max(SalaryCleaned, na.rm = T),
            Median = median(SalaryCleaned, na.rm = T))


# Plotting average salary by state
ggplot(data = salaryByState, 
       mapping = aes(x = State, 
                     y = Mean, 
                     fill = State)) +
  geom_bar(stat="identity", position = "dodge") +
  labs(title = "Average Salary By State") + 
  theme(axis.text.x = element_text(angle=45, hjust=1))


# Most popular job titles. Top 5 are highlighted
jobTitles <- as.data.frame(table(final_data$Job_Title))
colnames(jobTitles) <- c("Title", "Count")

jobTitles <- jobTitles %>%
  arrange(-Count) %>%
  head(5)


# Plotting above values
ggplot(data = jobTitles, 
       mapping = aes(x = Title, 
                     y = Count, 
                     fill = Title)) +
  geom_bar(stat="identity", position = "dodge") +
  labs(title = "Top 5 Job Titles") + 
  theme(axis.text.x = element_text(angle=45, hjust=1))


# Most popular Top level classifications. Top 5 are highlighted

topLevelClassifications <- as.data.frame(table(final_data$Industry))
colnames(topLevelClassifications) <- c("Title", "Count")

topLevelClassifications <- topLevelClassifications %>%
  arrange(-Count) %>%
  head(5)


# Plotting information above
ggplot(data = topLevelClassifications, 
       mapping = aes(x = Title, 
                     y = Count, 
                     fill = Title)) +
  geom_bar(stat="identity", position = "dodge") +
  labs(title = "Top 5 Top Level Classifications") + 
  theme(axis.text.x = element_text(angle=45, hjust=1))

# Salary comparison by top level classification
salaryByIndustry <- no_outliers %>%
  group_by(Industry) %>%
  summarise(Mean = mean(SalaryCleaned, na.rm = T)) %>%
  arrange(-Mean)


# Plorring result obtained above.
ggplot(data = salaryByIndustry, 
       mapping = aes(x = Industry, 
                     y = Mean, 
                     fill = Industry)) +
  geom_bar(stat="identity", position = "dodge") +
  labs(title = "Average Salary By Industry") + 
  theme(axis.text.x = element_text(angle=45, hjust=1))


# Positions posting by date,
postionsByDate <- final_data %>%
  group_by(JobDate) %>%
  summarise(Count = n())

# Creating a line chart.
ggplot(data = postionsByDate, 
       aes(x = JobDate,
           y = Count, 
           group = 1)) +
  geom_line(color="red")+
  geom_point() +
  labs(title = "Positions By Date") 

# Positions posted by week day.
postionsByWeekday <- final_data %>%
  group_by(weekday) %>%
  summarise(Count = n())

# Creating a line chart to show relationship between both
ggplot(data = postionsByWeekday, 
       aes(x = weekday,
           y = Count, 
           group = 1)) +
  geom_line(color="red")+
  geom_point() +
  labs(title = "Positions By Week Day") 
