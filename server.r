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
  ##Temp directory
  save_dir <- file.path(getwd(), "saved_data")
  dir.create(save_dir, showWarnings = FALSE)
  
  # tmp_dir <- tempfile(pattern = "shinytmp", tmpdir = file.path(getwd(), "tmp"))
  # dir.create(tmp_dir, showWarnings = FALSE)
  
  ## Next and previous button
  tab_id <- c("about", "study", "originalstudy", 
              "ratings_change", "outcome_changes", "comment")
  
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
      if (Current$Tab == "rating_changes" && is.null(input[["ratingmatrix_objchanges"]])) {
        showModal(modalDialog(
          title = "Warning",
          "Please indicate the difference in all dimensions!",
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
  
  

  ## For session tuning
  session$allowReconnect(TRUE)
  
#   ## Output datatable for dimension descriptions?
#   output$list_steps <- DT::renderDataTable({
#   DT::datatable(fmri_steps, options = list(pageLength = 25, searchHighlight = TRUE))
# })

  #############################################################
  # ## Output for selectOptionF_DYO
  # output$selectOptionF_DYO <- renderUI({
  #   st_sel_F <- input$selectStepF_DYO
  #   opts <- which(fmri_options$Steps==st_sel_F)
  #   opts_ <- fmri_options[opts, ]
  #   selectizeInput("selectOptionF_DYO2",
  #                  label   = "Select the option",
  #                  choices =  sort(c(opts_$Options)),
  #                  options=list(create=TRUE),
  #                  selected = sort(opts_$Options)[1]
  #   )
  # })
  # 
  # ## Output for selectOptionM_DYO
  # output$selectOptionM_DYO <- renderUI({
  #   st_sel_M <- input$selectStepM_DYO
  #   opts <- which(model_options$Steps==st_sel_M)
  #   opts_ <- model_options[opts, ]
  #   selectizeInput("selectOptionM_DYO2",
  #                  label   = "Select the option",
  #                  choices =  sort(c(opts_$Options)),
  #                  options=list(create=TRUE),
  #                  selected = sort(opts_$Options)[1]
  #   )
  # })
  # 
  # ## Output for selectOptionB_DYO
  # output$selectOptionB_DYO <- renderUI({
  #   st_sel_B <- input$selectStepB_DYO
  #   opts <- which(behav_options$Steps==st_sel_B)
  #   opts_ <- behav_options[opts, ]
  #   selectizeInput("selectOptionB_DYO2",
  #                  label   = "Select the option",
  #                  choices =  sort(c(opts_$Options)),
  #                  options=list(create=TRUE),
  #                  selected = sort(opts_$Options)[1]
  #   )
  # })
  # 
  # ## Create table for the pipeline
  # tableValuesF <- reactiveValues(df = data.frame(Steps = as.character(), Options = as.character(), 
  #                                                check.names = FALSE))
  # 
  # tableValuesM <- reactiveValues(df = data.frame(Steps = as.character(), Options = as.character(), 
  #                                                check.names = FALSE))
  # 
  # tableValuesB <- reactiveValues(df = data.frame(Steps = as.character(), Options = as.character(), 
  #                                                check.names = FALSE))
  # ###### Output of Bucket List #####
  # 
  # output$outputBucket <- renderText(input$Sparsity1)
  # output$OutputBucket2 <- renderText(input$Sparsity2)
  # output$OutputBucket3 <- renderText(input$Sparsity3)
  # output$OutputBucket4 <- renderText(input$Sparsity4)
  # output$OutputBucket5 <- renderText(input$Sparsity5)
  # 
  ##################################
  

  
  
  ## Create table for the survey
  StudyInputs <- c("RedoDOI", "OrigDOI",
  "OrigTitle","Objective",
  "RedoingLabel","Status")
#  QualInputNames <- c("rep_description", "rep_label", "rep_dims")
  RatingInputNames <- c("ratingmatrix_objchanges",
                        "ratingmatrix_expectations",
                        "ratingmatrix_intentions",
                        "ratingmatrix_cause_changes")
  
  OutcomeInputNames <- c("observedchange")
  
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
                                                                       aspects_matrix[match(cur_matrix$question_id, aspects_matrix_span)]), 
                                                                       Response = cur_matrix$response))
      }
    }
    for (name in OutcomeInputNames) {
      if (!is.null(input[[name]]) && length(input[[name]]) > 0) {
        data <- rbind(data, 
                      data.frame(Class = "results", Name = name, Response = input[[name]]))
      }
    }
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
    drive_upload(full_save_file_name, path = as_id("1Ut0RQ6P072CqV_XywXY_fH7g49RCbYwb"), name = save_file_name)
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