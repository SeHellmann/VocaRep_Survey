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
  tab_id <- c("about", "person", "study", "redo_desc", 
              "rating_obj", "rating_exp", "rating_intent", "comment")
  
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
      if (Current$Tab == "rating_obj" && is.null(input[["ratingmatrix1"]])) {
        showModal(modalDialog(
          title = "Warning",
          "Please indicate the difference in all dimensions!",
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
  PartInputNames <- c(question$Code)
  QualInputNames <- c("rep_description", "rep_label", "rep_dims")
  RatingInputNames <- c("ratingmatrix1")
  
  participantInputs <- reactive({
    data <- data.frame()
    for (name in PartInputNames) {
      #if (!is.null(input[[name]]) && length(input[[name]]) > 0) {
      options <- paste(input[[name]], collapse = ";")
      data <- rbind(data, data.frame(Class = "part", Name = name, Response = options))
      #}
    }
    for (name in QualInputNames) {
      #if (!is.null(input[[name]]) && length(input[[name]]) > 0) {
      options <- paste(input[[name]], collapse = ";")
      data <- rbind(data, data.frame(Class = "qual", Name = name, Response = options))
      #}
    }
    for (name in RatingInputNames) {
      #if (!is.null(input[[name]]) && length(input[[name]]) > 0) {
      cur_matrix <- input[[name]]
      data <- rbind(data, data.frame(Class = "rating", Name = paste0(name, "_", cur_matrix$question_id), Response = cur_matrix$response))
      #}
    }
    data <- rbind(data, data.frame(Class="additional", Name="comment", Response = input[["additional_info"]]))
  })

  observeEvent(input[["Next"]], {
    cat("rep_label:", input$rep_label, "\n")
    print(input$ratingmatrix1)
  })
  #  ## Create table for equivalence
  # selectInputNamesE <- c(equival$Code[40:length(equival$Code)])
  # userInputsE <- reactive({
  #   dataE <- data.frame()
  #   for (nameE in selectInputNamesE) {
  #     #if (!is.null(input[[name]]) && length(input[[name]]) > 0) {
  #     optionsE <- paste(input[[nameE]], collapse = ";")
  #     dataE <- rbind(dataE, data.frame(Name = nameE, Selection = optionsE))
  #     #}
  #   }
  #   dataE
  # })
  
  
  # output$keepAlive <- renderText({
  #   req(input$count)
  #   paste("Count", input$count)
  # })
  
  # autoInvalidate <- reactiveTimer(59000)
  # observe({
  #   autoInvalidate()
  #   cat(".")
  # })
  
  

### Submit button
observeEvent(input$end_survey, {
  if (is.null(input$Expert_ID) || input$Expert_ID == "") {
    showModal(modalDialog(
      title = "Warning",
      "Your ID is empty. Please enter your Last Name in About tab.",
      easyClose = TRUE,
      footer = modalButton("Close"),
      size = "l"
    ))
  } else {
    # data_to_save <- data.frame(ParticipantID = participant_id,
    #                            Question = survey_question,
    #                            ReplicationActivity = replication_activity,
    #                            stringsAsFactors = FALSE)
    # 
    # write.csv(data_to_save, "survey_data.csv", row.names = FALSE)
    
    
    
    sanitized_id <- gsub("[^[:alnum:]]", "_", stri_trans_general(input$Expert_ID, "Any-Latin; Latin-ASCII"))
    save_file_name <- sprintf("%s_data_%s.txt", sanitized_id, as.integer(Sys.time()))
    full_save_file_name <- file.path(save_dir, save_file_name)
    data_df <- participantInputs()
    write.csv(data_df, file=full_save_file_name)
    drive_upload(full_save_file_name, path = "VocaRep_Survey", name = save_file_name)
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