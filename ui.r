library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyjs)
library(conflicted)
#library(shinyalert)
conflicts_prefer(shinydashboardPlus::dashboardPage)
conflicts_prefer(shinydashboardPlus::dashboardSidebar)
conflicts_prefer(shinydashboardPlus::dashboardHeader)
conflicts_prefer(shinydashboardPlus::accordion)
conflicts_prefer(shinydashboard::box)
library(shinysurveys)
#shinysurveys::radioMatrixInput()
library(shinyBS)

library(shinyWidgets)
#radioGroupInput


source("Source_function.R")

ui <- dashboardPage(title = "Replication Survey", skin = "black",
                    ######################End of Dashboard Page############
                    dashboardHeader(title = img(src="metarep.jpg", height = "100%"), titleWidth = '230px'
                    ),
                    
                    
                    ##################End of Dashboard Header###############
                    dashboardSidebar(disable=FALSE,
                                     sidebarMenu(id = "tabs",
                                                 menuItem("Welcome", tabName = "about"),
                                                 #menuItem("Survey Information", tabName = "study"),
                                                 #menuItem("Participant information", tabName = "person"),
                                                 menuItem("General redoing Information", tabName = "originalstudy"),
                                                 menuItem("Changes in Dimensions", tabName = "ratings_change"),
                                                 #menuItem("Impact of Changes", tabName = "impact"),
                                                 menuItem("Comments", tabName = "comment")
                                     )
                    ),
                    ####################End of Dashboard Sidebar##################
                    dashboardBody(#style = "overflow: auto",
                      tags$script('$(".sidebar-menu a[data-toggle=\'tabs\']").click(function(){window.scrollTo({top: 0});})'),
                      # tags$script(HTML("$('body').addClass('fixed');")),
                      # tags$script("document.getElementsByClassName('sidebar-toggle')[0].style.visibility = 'hidden';"),
                      # tags$script("document.getElementsByClassName('sidebar')[0].style.visibility = 'hidden';"),
                      tags$style(HTML("
       .custom-text {
         color: black;
         font-size: 18px;
         text-align: justify;
         /* Add any other desired styles here */
       }
     ")),
     # tags$head(
     #   HTML(
     #     "
     #      <script>
     #      var socket_timeout_interval
     #      var n = 0
     #      $(document).on('shiny:connected', function(event) {
     #      socket_timeout_interval = setInterval(function(){
     #      Shiny.onInputChange('count', n++)
     #      }, 15000)
     #      });
     #      $(document).on('shiny:disconnected', function(event) {
     #      clearInterval(socket_timeout_interval)
     #      });
     #      </script>
     #      "
     #   )
     # ),
     
     tabItems(
       tabItem(tabName = "about",
               h2(strong("Welcome")),
               p("Dear participant,",br(), br(),
                 "Nowadays, many researchers re-do scientific activities 
                                  in multiple different forms as part of meta-scientific 
                                  endeavors. As members of a working group within the DFG Priority Program",
                 tags$a(href='https://www.meta-rep.uni-muenchen.de/index.html', "Meta-Rep project,"),
                 "we are conducting a survey to examine the different ways in which generalizability of 
                                  scientific findings can be investigated and tested.
                                  Our objective is to ascertain the extent to which 
                                  research findings can be applicable across diverse 
                                  scenarios and populations, with the ultimate aim of 
                                  bolstering the reliability of scientific inquiry. For 
                                  this, we need your help!",br(), br(),
                 "Our questionnaire will take about 10 minutes of your 
                                  time, and we would ask you to fill in the questionnaire 
                                  on a PC/laptop (and not on your mobile phone).",br(), br(),
                 "At the outset, we will need your consent to proceed with the survey. This 
                                  involves agreeing to the terms outlined. 
                                  We will be collecting data to analyze various dimensions of “redoing” studies, 
                                  with a commitment to transparency and ethical standards.",br(),br(),
                 "In the following section, you will have the opportunity to describe a “redoing” study 
                                  you are planning, conducting, or have completed. We will ask for information 
                                  such as the DOI of the “redoing” study, DOI of the 
                                  original study, objectives, status, and the outcome of the study (if known).",br(),br(),
                 "Finally, you will rate the differences between your “redoing” study and the original study,
                                  along different dimensions, such as empirical data, population, interventions, 
                                   outcome measures, analysis, research question, and theoretical frameworks.",br(), br(),
                 "Before you start with the questionnaire, we would like 
                                  to draw your attention to the following points about 
                                  the study listed below.",br(), br(),
                 "Thank you very much for your participation,",br(), br(),
                 "Prof. Dr. Felix Schönbrodt (LMU Munich) & the terminology 
                                  working group of the",
                 tags$a(href='https://www.meta-rep.uni-muenchen.de/index.html', "Meta-Rep project"),br(), br(),
                 class = "custom-text"),
               br(),
               accordion(
                 id = "some_accordion_information",
                 accordionItem(
                   title = "Study and Data Protection Information for Online Survey",
                   p("Under the following headings, you will find detailed explanations 
                                    of the study and data protection information. Simply click on the 
                                    individual questions if you would like further information.", class = "custom-text")
                 )
               ),
               h2(strong("Participant Confirmation")),
               p("I have read and understood the study and data protection information. I have had 
                                  sufficient time to decide whether to participate in the study or not. I am aware 
                                  that I can withdraw my consent without providing reasons. The legality of data 
                                  processing up to the time of withdrawal is not affected by this. Withdrawal can be 
                                  made at any time during the questionnaire. I agree to participate in the aforementioned 
                                  study for scientific research purposes.", class="custom-text"),
               radioButtons("part_conf1","", choices = c("No", "Yes"))#, choices = as.character(strsplit(question$Options[9], ";")[[1]])),
               
               
       ),
       
       #####################################Do Your Own##############################################################
       tabItem(tabName = "originalstudy",
               h2(strong("General information about the study")),
               p("The following questions are about your “redoing” study as well as the original study, to which  your redoing actitivity refers to."),br(),
               textInput("OrigDOI", "Provide the DOI(s) for easy reference to the original work(s). Seperate multiple entries with semicolons.", width = '100%'), # Name
               textInput("RedoDOI", "If available, provide the DOI for easy reference to your published article.", width = '100%'), # Name
               textInput("PreprintDOI", "If available, provide the DOI for easy reference to the preprint of your study.", width = '100%'), # Name
               textInput("RegistDOI", "If available, provide the DOI for easy reference to the preregistration of your study.", width = '100%'), # Name
               textInput("OrigTitle", "If the DOI was not available, provide the reference of the original study.", width = '100%'), # Name
               textAreaInput("Objective", "Briefly describe the main objectives or research questions of your redoing study.", width = '100%', height="20%"), # Name
               textInput("RedoingLabel", "What would you call your redoing activity? (e.g., replication, reproduction, robustness check) Please separate multiple entries by semicolons.", width = '100%'), # Name
               selectInput("Status", "What is the current status of your redoing activity?",
                           choices=c("Planning", "Ongoing", "Completed but not publicly available", "Completed with publicly available preprint", 
                                     "Completed with publicly available peer-reviewed article"), width = '90%'),
               
       ),
       tabItem(tabName = "ratings_change",
               fluidRow(
                 h4(strong("Objective change")),
                 p("Was there a quantitative/qualitative change along these dimensions relative to the original study? (Hover over dimensions and hold the mouse still for detailed explanation.)", class="custom-text"),
                 p(strong("Unknown/uncontrolled"), " means the dimension is relevant to the outcomes of the study, but it is unknown if the redoing study differed from the original study (e.g. because the information was not available in the original study or the dimensions was not controlled in the redoing study).", class="custom-text"),
                 shinysurveys::radioMatrixInput(
                   inputId="ratingmatrix_objchanges",
                   responseItems= aspects_matrix_span_objchanges, 
                   choices = options_matrix_objective, .required=FALSE
                 ),
                 # textInput("rep_dims", "If any relevant dimension was missed above, please specify which dimension you specifically changed or kept constant in your study.", placeholder = "..."),
                 # ),
                 br(), br(),
                 h4(strong("Reasons for the change or lack of change")),
                 p(HTML("What was the reason that the redoing study was changed or kept the same along this dimension, relative to the original study? (Hover over dimensions and hold the mouse still for detailed explanation.)<br/>Please select 'Not applicable', if the respective dimension does not apply to your study."), class="custom-text"),
                 shinysurveys::radioMatrixInput(
                   inputId="ratingmatrix_intentions",
                   responseItems=aspects_matrix_span_intentions, 
                   choices=options_matrix_intentions, .required=FALSE
                 )
               )
       ),
       
       tabItem("comment",
               h3("Thank you for your participation!"),
               br(),
               br(),
               textAreaInput("additional_info", "Do you have any additional comments about your redoing study?", "", width = '80%', height='40%'),
               br(),
               radioButtons(inputId="part_conf2",
                            label=div("Please confirm that you allow us to briefly store your input data on our server for compiling the report. The data will be deleted when you close this window.",
                                      style="white-space: nowrap;"),
                            choiceNames = list("I do not consent.", 
                                               "I do consent."),
                            choiceValues = list("No", "Yes"), selected = "No"),
               
               # Replace the old button with these new elements
               actionButton("compile_report", "Compile Report", icon = icon("file-text")),
               conditionalPanel(
                 condition = "input.compile_report > 0",
                 box(
                   title = "Report Preview",
                   width = 12,
                   status = "primary",
                   solidHeader = TRUE,
                   uiOutput("report_preview")
                 ),
                 downloadButton("download_report", "Download PDF Report", class = "btn-primary")
               )
       )
     ),
     #hidden(actionButton(inputId ="Previous", label = "Previous")),
     #hidden(actionButton(inputId ="Next", label = "Next")),
     fluidRow(
       column(1, uiOutput("prevButton"), align = "left"),
       column(1, uiOutput("nextButton"), align = "left")
     ),
     br(),
     br(),
                    )
     ###################End of Dashboard Body######################
)
