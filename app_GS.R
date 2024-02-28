library(shiny)
library(shinysurveys)
library(gsheet)
library(rio)

survey_def <- gsheet2tbl('https://docs.google.com/spreadsheets/d/12yZ0ZmpgZQOuaDSNLIOMKFrVIU3uZAGX6UrBi7MYbb8/edit?usp=sharing')

# save locally
export(survey_def, file="survey/demo_survey.xlsx")

ui <- fluidPage(
  surveyOutput(df = survey_def,
               survey_title = "Hello, World!",
               survey_description = "Welcome! This is a demo survey connected to a Google sheet.")
)

server <- function(input, output, session) {
  renderSurvey()
  
  observeEvent(input$submit, {
    showModal(modalDialog(
      title = "Congrats, you completed your first shinysurvey!",
      "You can customize what actions happen when a user finishes a survey using input$submit."
    ))
  })
}

shinyApp(ui, server)