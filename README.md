# RShiny-Work
It has the code for R shiny application and analysis of salary data analysis and machine learning,

The assignment instructions are below:

In this assessment you will investigate job opportunities for Data Scientist in Australia based on the data from the most popular job search website “Seek.com.au”. 
# Downloading data (25 points)
You must get your own data for this exam. You will use rvest package to scrape data from https:// www.seek.com.au/. As you are focused on Data Scientist jobs only, then your starting point will be https://www.seek.com.au/data-scientist-jobs. 
You don’t want to put too much pressure on the “Seek.com.au” website. Please, review all questions, make a plan of what data you need, then create one R-script to download all required data, clean the data and save the data as a dataframe on the hard-drive using functions save() or saveRDS(). Later you will run analysis and create a dashboard that will load your data file by functions load() or readRDS(). 
Test your code on a small piece of data. If everything works fine, then download full data just once, store it and then use stored data for the analysis. Try to avoid downloading the same data multiple times.
# Data analysis (50 points)
Question 0. Introduction to the business case, data available and analysis to be presented later. 
It might be beneficial if you write an introduction after you completed all other tasks. This way you would have a good understanding of what to put in this section as you already know what you’ve done and what data you’ve used.
Question 00. Conclusion at the end of the report briefly summarising all your findings. You have multiple questions to investigate, so you will have multiple topics to summarise in the conclusion. 
Question 1 “The state to be”. Study the number of positions with respect to states. Then study the distribution of salaries overall and then salaries with respect to the State. What are relationships between states, number of positions and salaries?
Question 2. “What's in a name?” Study the popularity of different job titles and then different industries (top level classification). Compare salaries in different industries. 
Question 3. “Seize the day, then let it go.” Study the number of positions advertised changes over time. Then analyse the relationship between day of the week and the number of positions. 
Hint: For this question to be processed correctly, I advise to download the data in the afternoon. I do suspect that Seek.com.au don’t use Adelaide time or even Australian time.
# Interactive dashboard (25 points)
You will create a dashboard using package shiny as an alternative delivery to the written report. The dashboard should cover the same topics as a report. Take care about a good design for the dashboard. One graph per screen is (probably) a bad idea (unless your graph is very detailed, and you need a lot of space for it). All graphs on one page could be a bad idea too (unless your graphs are very simple).
All graphs on the dashboard should be interactive. The dashboard is not a simple copy of the written report but an enhanced and interactive version of it. Numerical summary (e.g., table) is a data visualisation too for the purpose of a dashboard. Fell free to include them and try to make them interactive.

