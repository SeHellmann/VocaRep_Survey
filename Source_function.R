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



# question <- read_excel('Questions.xlsx')
# desc_dims <- read_excel("Dimensions.xlsx")


## Reading data with google sheets
library(gsheet)
desc_dims <- gsheet::gsheet2tbl("https://docs.google.com/spreadsheets/d/11ns4vgDIafxQmlEun4xLNHWd0Cj1KtrJHYWZn5p7L9Q/edit?usp=sharing")

### Personal information questions (removed)
# countryList <- read_excel("CountryList.xlsx")
# question <- gsheet::gsheet2tbl("https://docs.google.com/spreadsheets/d/1_3_-2JfLLYA5mI--k6sDs12LlS6pGtkMilNQG_wdw8k/edit?usp=sharing")

# library(rio)
# export(question, file="survey/Questions.xlsx")
# export(desc_dims, file="survey/Dimensions.xlsx")

options_matrix_objective <- c("Yes, there was a single change", "Yes, there was a set of changes", "No", "Unknown/ uncontrolled", "Not applicable", "Cannot answer")
options_matrix_intentions <- list("Theoretically motivated", "Pragmatically motivated", "Unmotivated", "Not applicable", "Cannot answer")
options_matrix_expectations <- list("No Impact", "Slight Impact", "Strong Impact", "Unknown Impact", "Not applicable", "Cannot answer")
options_matrix_causechanges <- list("No Impact", "Slight Impact", "Strong Impact", "Unknown Impact", "Not applicable", "Cannot answer")


aspects_matrix = desc_dims[["Dimension"]]
#aspects_matrix_span <- list()
aspects_matrix_span_objchanges <- list()
aspects_matrix_span_intentions <- list()
aspects_matrix_span_expectedchanges <- list()
aspects_matrix_span_causechanges  <- list()
for (i in 1:length(aspects_matrix)) {
  # The paste with blanks is a work around to omit the radio matrix inputs to be considered identical
  aspects_matrix_span_objchanges[[i]] <- span(aspects_matrix[i], title=paste0(desc_dims[["Description"]][i], " ")) 
  aspects_matrix_span_intentions[[i]] <- span(aspects_matrix[i], title=paste0(desc_dims[["Description"]][i], "  ")) 
  aspects_matrix_span_expectedchanges[[i]] <- span(aspects_matrix[i], title=paste0(desc_dims[["Description"]][i], "   "))  
  aspects_matrix_span_causechanges[[i]] <- span(aspects_matrix[i], title=paste0(desc_dims[["Description"]][i], "    ")) 
  
}

# 
# library(googledrive)
# drive_auth(cache = here::here(".secrets"), email = TRUE)

# # Alternative (glaube ich):
# options(
#   # whenever there is one account token found, use the cached token
#   gargle_oauth_email = TRUE,
#   # specify auth tokens should be stored in a hidden directory ".secrets"
#   gargle_oauth_cache = ".secrets"
# )
# drive_auth()
