library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyjs)
library(stringi)
library(googledrive)
## For rendering the report output
library(rmarkdown)
library(pagedown) # Optional for better PDF rendering
#library(dplyr)
#library(stringr)
#library(png)
#library(DT)
#library(rintrojs)
#library(qdapTools)
#library(bslib)
#library(httr)
#library(zip)
#library(sortable)
#library(conflicted)
#library(shinyalert)

server <- function(input, output, session){
  #shinyalert(title = "Welcome!", text = "This survey has not been launched yet. Please just browse and do not post your answers. It will be launched soon.", type = "info")
  
  shinyjs::addClass(selector = "body", class = "sidebar-collapse")
  
  ##Temp directory
  save_dir <- file.path(getwd(), "saved_data")
  dir.create(save_dir, showWarnings = FALSE)
  
  # tmp_dir <- tempfile(pattern = "shinytmp", tmpdir = file.path(getwd(), "tmp"))
  # dir.create(tmp_dir, showWarnings = FALSE)
  
  ## Next and previous button
  tab_id <- c("about", "originalstudy", 
              "ratings_change", "comment")
  
  # observe({
  #   lapply(c("Next", "Previous"),
  #          toggle,
  #          condition = input[["tabs"]] != "about")
  # })
  
  Current <- reactiveValues(
    Tab = "about"
  )
  
  observeEvent(
    input[["tabs"]],
    {
      Current$Tab <- input[["tabs"]]
    }
  )
  
  output$nextButton <- renderUI({
  if (input$tabs != "comment") {
    actionButton("Next", "Next")
  }
})

 output$prevButton <- renderUI({
  if (input$tabs != "about") {
    actionButton("Previous", "Previous")
  }
})

  observeEvent(
    input[["Previous"]],
    {
      tab_id_position <- match(Current$Tab, tab_id) - 1
      if (tab_id_position == 0) tab_id_position <- length(tab_id)
      Current$Tab <- tab_id[tab_id_position]
      updateTabItems(session, "tabs", tab_id[tab_id_position]) 
    }
  )
  
  observeEvent(
    input[["Next"]],
    {
      if (Current$Tab == "ratings_change" && (is.null(input[["ratingmatrix_objchanges"]]) ||
                                              is.null(input[["ratingmatrix_intentions"]]))) {
        showModal(modalDialog(
          title = "Warning",
          "Please indicate the difference and the intentions in all dimensions!",
          easyClose = TRUE,
          footer = modalButton("Close"),
          size = "l"
        ))
      # } else if (Current$Tab == "impact" && (is.null(input[["ratingmatrix_impact"]]))) {
      #   showModal(modalDialog(
      #     title = "Warning",
      #     "Please indicate the expected influence on the outcome of all dimensions!",
      #     easyClose = TRUE,
      #     footer = modalButton("Close"),
      #     size = "l"
      #   ))
      } else if (Current$Tab == "about" && (input[["part_conf1"]]!="Yes")) {
        showModal(modalDialog(
          title = "Please confirm your consent",
          "Please confirm that you have read and agree with the participant information.",
          easyClose = TRUE,
          footer = modalButton("Close"),
          size = "l"
        ))
      } else {
        tab_id_position <- match(Current$Tab, tab_id) + 1
        if (tab_id_position > length(tab_id)) tab_id_position <- 1
        Current$Tab <- tab_id[tab_id_position]
        updateTabItems(session, "tabs", tab_id[tab_id_position]) 
      }
    }
  )
  
  
  # ## Dynamically create the matrix question 
  # ## "Expected/observed impact of the change on the results"
  # 
  # output$impact_tabs <- renderUI({
  #   if(input$is_result_observed == FALSE) {
  #     list(
  #       p(HTML("What is the <b>expected</b> impact that the change on the respective dimensions of the redoing study would have on the results of the study, relative to the original study? (Hover over dimensions and hold the mouse still for detailed explanation.)<br/>Please select 'Not applicable', if the respective dimension was identical in the redoing study."), class="custom-text"),
  #     shinysurveys::radioMatrixInput(
  #       inputId="ratingmatrix_impact",
  #       responseItems= aspects_matrix_span_impact, 
  #       choices = options_matrix_impact, .required=FALSE
  #     ) 
  #     )
  #   } else {
  #     list(
  #       p(HTML("What is the <b>observed</b> impact that the change on this dimension of the redoing study has had on the results of the study, relative to the original study? (Hover over dimensions and hold the mouse still for detailed explanation.)<br/>Please select 'Not applicable', if the respective dimension was identical in the redoing study."), class="custom-text"),
  #       shinysurveys::radioMatrixInput(
  #         inputId="ratingmatrix_impact",
  #         responseItems= aspects_matrix_span_impact,
  #         choices = options_matrix_impact, .required=FALSE
  #       )
  #     )
  #   }
  # })
  # 
  

  ## For session tuning
  session$allowReconnect(TRUE)
  
  
  ## Create table for the survey
  StudyInputs <- c("RedoDOI", "OrigDOI","PreprintDOI", "RegistDOI",
  "OrigTitle","Objective",
  "RedoingLabel","Status")
#  QualInputNames <- c("rep_description", "rep_label", "rep_dims")
  RatingInputNames <- c("ratingmatrix_objchanges",
                        "ratingmatrix_intentions")
  
  participantInputs <- reactive({
    data <- data.frame()
    for (name in StudyInputs) {
      if (!is.null(input[[name]]) && length(input[[name]]) > 0) {
        #options <- paste(input[[name]], collapse = ";")
        data <- rbind(data, 
                      data.frame(Class = "study", Name = name, Response = input[[name]]))
      }
    }

    for (name in RatingInputNames) {
      if (!is.null(input[[name]]) && length(input[[name]]) > 0) {
        cur_matrix <- input[[name]]
        data <- rbind(data, data.frame(Class = "rating", Name = paste0(name, "_", 
                                                                       aspects_matrix), 
                                                                       Response = cur_matrix$response))
      }
    }

    data <- rbind(data, data.frame(Class="additional", Name="comment", Response = input[["additional_info"]]))
  })
  
  
  # Add some reactive path value
  report_path <- reactiveVal(NULL)
  session_dir <- paste0("www/", session$token)
  dir.create(session_dir, showWarnings = FALSE, recursive = TRUE)
  
### Submit button
observeEvent(input$compile_report, {

  # Validate consent
  if (input[["part_conf2"]] != "Yes") {
    showModal(modalDialog(
      title = "Warning",
      "Please confirm your consent to the participation.",
      easyClose = TRUE,
      footer = modalButton("Close"),
      size = "l"
    ))
    return()
  }
  
  # Show loading modal
  showModal(modalDialog(
    title = "Generating Report",
    "Please wait while we compile your survey responses and generate the report...",
    footer = NULL
  ))
  
  # Prepare data for saving
  data_df <- participantInputs()
  save_file_name <- sprintf("data_%s.txt", as.integer(Sys.time()))
  full_save_file_name <- file.path(save_dir, save_file_name)
  write.csv(data_df, file = full_save_file_name)
  
  
  # Prepare parameters for the report
  params <- list(
    OrigDOI     = input$OrigDOI,
    RedoDOI     = input$RedoDOI,
    PreprintDOI = input$PreprintDOI,
    RegistDOI   = input$RegistDOI,
    OrigTitle = input$OrigTitle,
    Objective = input$Objective,
    RedoingLabel = input$RedoingLabel,
    Status = input$Status,
    ratingmatrix_objchanges = input$ratingmatrix_objchanges,
    ratingmatrix_intentions = input$ratingmatrix_intentions,
    additional_info = input$additional_info,
    survey_data = data_df  # Include the raw data for reference
  )
  print(dput(params))
  tryCatch({
    # Create temp files
    # Create output filename
    pdf_filename <- paste0("report_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".pdf")
    pdf_path <- file.path(session_dir, pdf_filename)
    #temp_html <- tempfile(fileext = ".html", tmpdir = session_dir)
    
    # Render with MiKTeX
    rmarkdown::render(
      input = "report_template.Rmd",
      output_file = pdf_path,
      params = params,
      envir = new.env(),
      output_format = pdf_document(
        latex_engine = "xelatex",
        pandoc_args = c("--pdf-engine=xelatex")
      )
    )
    

    # # Render HTML preview
    # rmarkdown::render(
    #   input = "report_template.Rmd",
    #   output_file = temp_html,
    #   output_format = "html_document",
    #   params = params,
    #   envir = new.env()
    # )
    
    # Store relative path (without www/)
    relative_path <- paste0(session$token, "/", pdf_filename)
    report_path(relative_path)
    
    showNotification(paste("PDF saved at:", relative_path))
      
      
        # Display preview
        output$report_preview <- renderUI({
          tags$iframe(
            src = relative_path,
            width = "100%",
            height = "800px",
            style = "border: none;"
          )
        })
  
      removeModal()
      
      # Show success message
      showNotification("Report generated successfully!", type = "message")
      }, error = function(e) {
        removeModal()
        showNotification(paste("Error generating report:", e$message), type = "error")
      })
})

# Download handler
output$download_report <- downloadHandler(
  filename = function() {
    paste0("Redoing_Study_Report_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".pdf")
  },
  content = function(file) {
    req(report_path())
    full_path <- file.path("www", report_path())
    if (file.exists(full_path)) {
      file.copy(full_path, file)
    } else {
      showNotification(paste("File not found at:", full_path), type = "error")
    }
  },
  contentType = "application/pdf"
)
# Clean up session files when session ends
session$onSessionEnded(function() {
  unlink(session_dir, recursive = TRUE)
})
}