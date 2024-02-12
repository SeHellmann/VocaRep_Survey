library(shiny)
library(shinysurveys)
library(dplyr)
library(tidyr)
dir.create("data", showWarnings = FALSE)
# Create a data frame with your survey questions
survey_title = "Shared vocabulary for replications"
survey_desc = "Thank you for participating in our survey. Please provide information about replication activities that you have previously conducted."


### Options and dimensions for the matrix question:
options_matrix <- c("Exactly the same", "Approximately the same", "Different", "Not applicable")
aspects_matrix = c(
  "Computational Environment",
  "Analysis Code",
  "Statistical Analysis",
  "Data",
  "Sample Properties",
  "Operationalisation (IV)",
  "Operationalisation (DV)",
  "Research Question"
)
n_options <- length(options_matrix)
n_aspects <- length(aspects_matrix)

survey_df_1 <- data.frame(
  question = c(
    "Please, think of your most recent re-doing/replication activity.\nHow would you call this kind of re-doing activity?",
    "What aspects of the original study did you change or keep constant?",
    rep(aspects_matrix, each=n_options)),
  option = c(NA, NA, rep(options_matrix, n_aspects)),
  input_type = c("text","text", rep("matrix", n_aspects*n_options)),
  input_id = c("rep1","original_study_aspects1", rep("table1", n_aspects*n_options)),
  dependence = NA,
  dependence_value = NA,
  required = c(TRUE,FALSE, FALSE, rep(TRUE, (n_aspects*n_options)-1)), # Issue: cannot set required to 1 in the matrix question
  page="page1"
)
survey_df_2 <- data.frame(
  question = c(
    "Now, think of your second-most recent re-doing/replication activity (if available).\nHow would you call this kind of re-doing activity?",
    "What aspects of the original study did you change or keep constant?",
    rep(aspects_matrix, each=n_options)),
  option = c(NA, NA, rep(options_matrix, n_aspects)),
  input_type = c("text","text", rep("matrix", n_aspects*n_options)),
  input_id = c("rep2","original_study_aspects2", rep("table2", n_aspects*n_options)),
  dependence = NA,
  dependence_value = NA,
  required = c(TRUE,FALSE, FALSE, rep(TRUE, (n_aspects*n_options)-1)), # Issue: cannot set required to 1 in the matrix question
  page="page2"
)
survey_df <- rbind(survey_df_1, survey_df_2)


# Define the UI
ui <- fluidPage(
  surveyOutput(
    df = survey_df,
    survey_title = survey_title,
    survey_description = survey_desc,
    theme = "#009999"
  )
)

# Define the server
server <- function(input, output, session) {
  renderSurvey()
  
  observeEvent(input$submit, {
    # Process survey data here (e.g., save to a database)
    #print(getSurveyData())
    #write.csv(getSurveyData(), file=paste0("data/part_", round(runif(1)*100000)))
    showModal(
      modalDialog(
        title = "Thank you!",
        "Your survey responses have been recorded."
      )
    )
  })
}

# Run the Shiny app
shinyApp(ui, server)
