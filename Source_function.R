# library(shiny)
# library(shinydashboard)
# library(shinydashboardPlus)
# library(shinyjs)
# library(dplyr)
# library(stringr)
# library(png)
# library(DT)
# library(rintrojs)
# library(qdapTools)
# library(bslib)
# library(httr)
# library(zip)
library(readxl)

#Sys.setlocale('LC_ALL', 'C')

#####################
#####Reading data####
#####################
countryList <- read_excel("CountryList.xlsx")


# question <- read_excel('Questions.xlsx')
# desc_dims <- read_excel("Dimensions.xlsx")


## Reading data with google sheets
library(gsheet)
desc_dims <- gsheet::gsheet2tbl("https://docs.google.com/spreadsheets/d/11ns4vgDIafxQmlEun4xLNHWd0Cj1KtrJHYWZn5p7L9Q/edit?usp=sharing")
question <- gsheet::gsheet2tbl("https://docs.google.com/spreadsheets/d/1_3_-2JfLLYA5mI--k6sDs12LlS6pGtkMilNQG_wdw8k/edit?usp=sharing")
# library(rio)
# export(question, file="survey/Questions.xlsx")
# export(desc_dims, file="survey/Dimensions.xlsx")


options_matrix <- c("Not at all different", "Slighly different", "Substantially different", "Unknown/uncontrolled", "Not applicable")
aspects_matrix = desc_dims[["Dimension"]]
n_options <- length(options_matrix)
n_aspects <- length(aspects_matrix)



