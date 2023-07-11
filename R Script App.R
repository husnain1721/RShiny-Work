#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.


library(shiny)
library(ggplot2)
library(dplyr)
library(lubridate)

ui <- fluidPage(
  titlePanel("Job Data Analysis Dashboard"),
  sidebarLayout(
    sidebarPanel(
      tabsetPanel(
        tabPanel("Upload Data",
                 fileInput("file1", "Choose CSV File",
                           accept = c(".csv")),
                 checkboxInput("header", "Header", TRUE),
                 actionButton("submit", "Submit")
        )
      )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Positions By State", plotOutput("positionsByStatePlot")),
        tabPanel("Salary Distribution", plotOutput("salaryDistributionPlot")),
        tabPanel("Average Salary By State", plotOutput("averageSalaryByStatePlot")),
        tabPanel("Top 5 Job Titles", plotOutput("topJobTitlesPlot")),
        tabPanel("Top 5 Top Level Classifications", plotOutput("topLevelClassificationsPlot")),
        tabPanel("Average Salary By Industry", plotOutput("averageSalaryByIndustryPlot")),
        tabPanel("Positions By Date", plotOutput("positionsByDatePlot")),
        tabPanel("Positions By Week Day", plotOutput("positionsByWeekdayPlot"))
      )
    )
  )
)

server <- function(input, output) {
  
  data <- reactive({
    req(input$file1)
    inFile <- input$file1
    df <- read.csv(inFile$datapath, header = input$header)
    df
  })
  
  # Plotting number of positions posted by state
  output$positionsByStatePlot <- renderPlot({
    positionsByState <- data() %>%
      group_by(State) %>%
      summarise(Positions = n()) %>%
      arrange(-Positions)
    
    ggplot(data = positionsByState, 
           mapping = aes(x = State, 
                         y = Positions, 
                         fill = State)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Number of Positions By State") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  # Plotting salary distribution
  output$salaryDistributionPlot <- renderPlot({
    salaryCleandData <- read.csv("SalaryCleaned.csv")
    ggplot(data = salaryCleandData, 
           aes(x = SalaryCleaned)) +
      geom_histogram(binwidth = 10000, 
                     fill = "steelblue", 
                     color = "orange") +
      labs(x = "Salary", 
           y = "Frequency", 
           title = "Salary Distribution")
  })
  
  # Plotting average salary by state
  output$averageSalaryByStatePlot <- renderPlot({
    salaryCleandData <- read.csv("SalaryCleaned.csv")
    salaryByState <- salaryCleandData %>%
      group_by(State) %>%
      summarise(Mean = mean(SalaryCleaned, na.rm = TRUE),
                Min = min(SalaryCleaned, na.rm = TRUE),
                Max = max(SalaryCleaned, na.rm = TRUE),
                Median = median(SalaryCleaned, na.rm = TRUE))
    
    ggplot(data = salaryByState, 
           mapping = aes(x = State, 
                         y = Mean, 
                         fill = State)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Average Salary By State") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  # Plotting top 5 job titles
  output$topJobTitlesPlot <- renderPlot({
    jobTitles <- as.data.frame(table(data()$Job_Title))
    colnames(jobTitles) <- c("Title", "Count")
    
    jobTitles <- jobTitles %>%
      arrange(-Count) %>%
      head(5)
    
    ggplot(data = jobTitles, 
           mapping = aes(x = Title, 
                         y = Count, 
                         fill = Title)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Top 5 Job Titles") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  # Plotting top 5 top level classifications
  output$topLevelClassificationsPlot <- renderPlot({
    topLevelClassifications <- as.data.frame(table(data()$Industry))
    colnames(topLevelClassifications) <- c("Title", "Count")
    
    topLevelClassifications <- topLevelClassifications %>%
      arrange(-Count) %>%
      head(5)
    
    ggplot(data = topLevelClassifications, 
           mapping = aes(x = Title, 
                         y = Count, 
                         fill = Title)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Top 5 Top Level Classifications") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  # Plotting average salary by industry
  output$averageSalaryByIndustryPlot <- renderPlot({
    salaryCleandData <- read.csv("SalaryCleaned.csv")
    salaryByIndustry <- salaryCleandData %>%
      group_by(Industry) %>%
      summarise(Mean = mean(SalaryCleaned, na.rm = TRUE)) %>%
      arrange(-Mean)
    
    ggplot(data = salaryByIndustry, 
           mapping = aes(x = Industry, 
                         y = Mean, 
                         fill = Industry)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Average Salary By Industry") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  # Plotting positions by date
  output$positionsByDatePlot <- renderPlot({
    postionsByDate <- data() %>%
      group_by(JobDate) %>%
      summarise(Count = n())
    
    ggplot(data = postionsByDate, 
           aes(x = JobDate,
               y = Count, 
               group = 1)) +
      geom_line(color = "red") +
      geom_point() +
      labs(title = "Positions By Date") 
  })
  
  # Plotting positions by week day
  output$positionsByWeekdayPlot <- renderPlot({
    postionsByWeekday <- data() %>%
      group_by(weekday) %>%
      summarise(Count = n())
    
    ggplot(data = postionsByWeekday, 
           aes(x = weekday,
               y = Count, 
               group = 1)) +
      geom_line(color = "red") +
      geom_point() +
      labs(title = "Positions By Week Day") 
  })
}

shinyApp(ui = ui, server = server)