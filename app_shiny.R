library(shiny)
library(shinyjs)
library(shinysurveys)

dir.create("data", showWarnings = FALSE)

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


# Define server
server <- function(input, output, session) {
    # Reactive values to store input values
    input_values <- reactiveValues(
      rep1 = "",
      rep2 = "",
      matrix1 = rep(options_matrix[4], n_aspects),
      matrix2 = rep(options_matrix[4], n_aspects)
    )
    
  
  # Initial page number
  current_page <- reactiveVal(1)
  
  # Function to render page content based on current_page
  render_page <- function() {
    if (current_page() == 1) {
      return(tagList(
          p("Thank you for participating in our survey. Please provide information about replication activities that you have previously conducted."),
          h3("Most recent re-doing activity"),
          p("Please, think of your most recent re-doing/replication activity."),
          textInput("rep1", "How would you call this kind of re-doing activity? (E.g. reproduction, direct replication, conceptual replication,...)",
                    value = input_values$rep1),
          p("What aspects of the original study did you change or keep constant?"),
          radioMatrixInput(
            "redo_activity_table_1",
            responseItems= aspects_matrix, choices = options_matrix, .required=FALSE,
            selected = input_values$matrix1
          )
        ))
    } else {
      return(tagList(
          p("Thank you for participating in our survey. Please provide information about replication activities that you have previously conducted."),
          h3("Second-most recent re-doing activity"),
          p("Now, think of your second-most recent re-doing/replication activity (if available).\nHow would you call this kind of re-doing activity?"),
          textInput("rep2", "How would you call this kind of re-doing activity? (E.g. reproduction, direct replication, conceptual replication,...)",
                    value = input_values$rep2),
          p("What aspects of the original study did you change or keep constant?"),
          radioMatrixInput(
            "redo_activity_table_2",
            responseItems= aspects_matrix, choices = options_matrix, .required=FALSE,
            selected = input_values$matrix2
          )
        ))
    }
  }
  
  # Initial render
  # Render initial page
  output$page_content <- renderUI({render_page()})
  
  
  # Track changes in input values
  observeEvent(input$rep1, {
    input_values$rep1 <- input$rep1
  })
  observeEvent(input$rep2, {
    input_values$rep2 <- input$rep2
  })
  observeEvent(input$redo_activity_table_1, {
    input_values$matrix1 <- input$redo_activity_table_1
  })
  observeEvent(input$redo_activity_table_2, {
    input_values$matrix1 <- input$redo_activity_table_2
  })
  
  
  # Observe event for Next button
  observeEvent(input$next_button, {
    cat("rep1:", input_values$rep1, "\n")
    cat("rep2:", input_values$rep2, "\n")
    cat("matrix2:", input_values$matrix2, "\n")
    
    current_page(current_page() + 1)
    shinyjs::disable("next_button")
    shinyjs::enable("submit_button")
    shinyjs::enable("prev_button")
    output$page_content <- renderUI({
      render_page()
    })
    
  })
  
  # Observe event for Previous button
  observeEvent(input$prev_button, {
    shinyjs::enable("next_button")
    shinyjs::disable("submit_button")
    shinyjs::disable("prev_button")
    current_page(current_page() - 1)
    output$page_content <- renderUI({
      render_page()
    })
  })
  
  # Dynamically control visibility of Next button
  # observe({
  #   if (current_page() == 1) {
  #     shinyjs::enable("next_button")
  #     shinyjs::disable("submit_button")
  #     shinyjs::disable("prev_button")
  #   } else {
  #     shinyjs::disable("next_button")
  #     shinyjs::enable("submit_button")
  #     shinyjs::enable("prev_button")
  #   }
  # })
  
  ## If submitted, save data and quit shiny app
  observeEvent(input$submit_button, {
    # Get input values
    participant_id <- round(runif(1)*10000)
    rep1 <- input$rep1
    rep2 <- input$rep2

    # Add data to the survey_data data frame
    data_to_save <- data.frame(ParticipantID = participant_id,
                           Question = survey_question,
                           ReplicationActivity = replication_activity,
                           stringsAsFactors = FALSE)
    
    write.csv(data_to_save, "survey_data.csv", row.names = FALSE)
    
    # Display thank you message and quit the app
    showModal(
      modalDialog(
        title = "Thank You!",
        "Your data has been saved.",
        footer = tagList(
          modalButton("Close", onclick = shinyjs::jsCode("Shiny.onInputChange('closeApp', true);"))
        )
      )
    )
  })
  
  
  # Observe closeApp and stop the app if it's TRUE
  observe({
    if (!is.null(input$closeApp) && input$closeApp) {
      stopApp()
    }
  })
  
}



# Define UI
ui <- fluidPage(useShinyjs(),
  titlePanel("Shared vocabulary for replications"),
  uiOutput("page_content"),
  actionButton("next_button", "Next"),
  actionButton("prev_button", "Previous"),
  actionButton("submit_button", "Submit Data")
)
# Run the Shiny app
shinyApp(ui, server)