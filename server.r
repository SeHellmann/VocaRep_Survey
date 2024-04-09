library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyjs)
library(stringi)
library(googledrive)
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
              "ratings_change", "impact", "comment")
  
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
      } else if (Current$Tab == "impact" && (is.null(input[["ratingmatrix_impact"]]))) {
        showModal(modalDialog(
          title = "Warning",
          "Please indicate the expected influence on the outcome of all dimensions!",
          easyClose = TRUE,
          footer = modalButton("Close"),
          size = "l"
        ))
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
  
  
  ## Dynamically create the matrix question 
  ## "Expected/observed impact of the change on the results"
  
  output$impact_tabs <- renderUI({
    if(input$is_result_observed == FALSE) {
      list(
        p(HTML("What is the <b>expected</b> impact that the change on the respective dimensions of the redoing study would have on the results of the study, relative to the original study? (Hover over dimensions and hold the mouse still for detailed explanation.)<br/>Please select 'Not applicable', if the respective dimension was identical in the redoing study."), class="custom-text"),
      shinysurveys::radioMatrixInput(
        inputId="ratingmatrix_impact",
        responseItems= aspects_matrix_span_impact, 
        choices = options_matrix_impact, .required=FALSE
      ) 
      )
    } else {
      list(
        p(HTML("What is the <b>observed</b> impact that the change on this dimension of the redoing study has had on the results of the study, relative to the original study? (Hover over dimensions and hold the mouse still for detailed explanation.)<br/>Please select 'Not applicable', if the respective dimension was identical in the redoing study."), class="custom-text"),
        shinysurveys::radioMatrixInput(
          inputId="ratingmatrix_impact",
          responseItems= aspects_matrix_span_impact,
          choices = options_matrix_impact, .required=FALSE
        )
      )
    }
  })
  
  

  ## For session tuning
  session$allowReconnect(TRUE)
  
  
  ## Create table for the survey
  StudyInputs <- c("RedoDOI", "OrigDOI",
  "OrigTitle","Objective",
  "RedoingLabel","Status", "Observedchange", "is_result_observed")
#  QualInputNames <- c("rep_description", "rep_label", "rep_dims")
  RatingInputNames <- c("ratingmatrix_objchanges",
                        "ratingmatrix_intentions",
                        "ratingmatrix_impact")
  
  participantInputs <- reactive({
    data <- data.frame()
    for (name in StudyInputs) {
      if (!is.null(input[[name]]) && length(input[[name]]) > 0) {
        #options <- paste(input[[name]], collapse = ";")
        data <- rbind(data, 
                      data.frame(Class = "study", Name = name, Response = input[[name]]))
      }
    }
    # for (name in QualInputNames) {
    #   if (!is.null(input[[name]]) && length(input[[name]]) > 0) {
    #     options <- paste(input[[name]], collapse = ";")
    #     data <- rbind(data, data.frame(Class = "qual", Name = name, Response = options))
    #   }
    # }
    for (name in RatingInputNames) {
      if (!is.null(input[[name]]) && length(input[[name]]) > 0) {
        cur_matrix <- input[[name]]
        data <- rbind(data, data.frame(Class = "rating", Name = paste0(name, "_", 
                                                                       aspects_matrix), 
                                                                       Response = cur_matrix$response))
      }
    }
    # for (name in OutcomeInputNames) {
    #   if (!is.null(input[[name]]) && length(input[[name]]) > 0) {
    #     data <- rbind(data, 
    #                   data.frame(Class = "results", Name = name, Response = input[[name]]))
    #   }
    # }
    data <- rbind(data, data.frame(Class="additional", Name="comment", Response = input[["additional_info"]]))
  })

  ### For debugging:
  # observeEvent(input[["Next"]], {
  #   cat("rep_label:", input$rep_label, "\n")
  #   print(input$ratingmatrix1)
  # })

  

### Submit button
observeEvent(input$end_survey, {
    # data_to_save <- data.frame(ParticipantID = participant_id,
    #                            Question = survey_question,
    #                            ReplicationActivity = replication_activity,
    #                            stringsAsFactors = FALSE)
    # 
    # write.csv(data_to_save, "survey_data.csv", row.names = FALSE)
  if (input[["part_conf2"]]!="Yes") {
    showModal(modalDialog(
      title = "Warning",
      "Please confirm your consent to the participation.",
      easyClose = TRUE,
      footer = modalButton("Close"),
      size = "l"
    ))
  } else {
    save_file_name <- sprintf("data_%s.txt", as.integer(Sys.time()))
    full_save_file_name <- file.path(save_dir, save_file_name)
    data_df <- participantInputs()
    write.csv(data_df, file=full_save_file_name)
    #drive_upload(full_save_file_name, path = as_id("1Ut0RQ6P072CqV_XywXY_fH7g49RCbYwb"), name = save_file_name)
  #     https://drive.google.com/drive/folders/1Ut0RQ6P072CqV_XywXY_fH7g49RCbYwb?usp=sharing
    showModal(modalDialog(
      title = "Survey Ended!",
      "Thank you for your participation. Your data has been saved. You can now close the survey.",
      easyClose = TRUE,
      footer = tagList(
        modalButton("Close")
      ),
      size = "l"
    ))
  }
})


  # session$onSessionEnded(function() {
  #   # Delete the temporary directory and its contents
  #   unlink(tmp_dir, recursive = TRUE, force = TRUE)
  # })
  
}