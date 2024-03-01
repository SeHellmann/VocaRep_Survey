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

Sys.setlocale('LC_ALL', 'C')

#####################
#####Reading data####
#####################
#fmri_steps <- read_excel("fMRI_steps.xlsx")
#fmri_options <- read_excel('fMRI_options.xlsx')
question <- read_excel('Questions_rf.xlsx')
#equival <- read_excel('Equival.xlsx')
countryList <- read_excel("CountryList.xlsx")
desc_dims <- read_excel("Dimensions.xlsx")

#behav_steps <- read_excel("Steps_Behavior.xlsx", sheet = "Steps")
#behav_options <- read_excel("Steps_Behavior.xlsx", sheet = "Options")
#model_steps <- read_excel("Steps_Brain_Behavior.xlsx", sheet = "Steps")
#model_options <- read_excel("Steps_Brain_Behavior.xlsx", sheet = "Options")
options_matrix <- c("Not at all different", "Slighly different", "Substantially different", "Unknown/uncontrolled", "Not applicable")
aspects_matrix = desc_dims[["Dimension"]]
# c(
#   "Computational Environment",
#   "Analysis Code",
#   "Statistical Analysis",
#   "Data",
#   "Sample Properties",
#   "Operationalisation (IV)",
#   "Operationalisation (DV)",
#   "Research Question"
# )
n_options <- length(options_matrix)
n_aspects <- length(aspects_matrix)

dav <- "https://cloud.uol.de/remote.php/webdav/Output_survey"
username <- "mort4924"
password <- "StatSpaßfUnity22.+"



