library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyjs)
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
library(conflicted)
#library(shinyalert)
conflicts_prefer(shinydashboardPlus::dashboardPage)
conflicts_prefer(shinydashboardPlus::dashboardSidebar)
conflicts_prefer(shinydashboardPlus::dashboardHeader)
conflicts_prefer(shinydashboardPlus:: accordion)
conflicts_prefer(shinydashboard::box)
library(shinysurveys)
#shinysurveys::radioMatrixInput()

library(shinyWidgets)
#radioGroupInput

source("Source_function.R")

ui <- dashboardPage(title = "Replication Survey", skin = "black",
                    ######################End of Dashboard Page############
                    dashboardHeader(title = img(src="metarep.jpg", height = "100%"), titleWidth = '230px'
                    ),
                    
                    
                    ##################End of Dashboard Header###############
                    dashboardSidebar(width = 270,
                                     sidebarMenu(id = "tabs", style = "position: fixed; overflow: auto; width: 270px;",
                                                 menuItem("ABOUT", tabName = "about"),
                                                 menuItem("Participant information", tabName = "person"),
                                                 menuItem("Study information", tabName = "study"),
                                                 menuItem("Redoing activity", tabName = "redo",
                                                          menuSubItem("Description", tabName = "redo_desc"),
                                                          menuSubItem("Rating of objective change", tabName = "rating_obj"),
                                                          menuSubItem("Rating of expected difference", tabName = "rating_exp"),
                                                          menuSubItem("Rating of intentions", tabName = "rating_intent")
                                                 ),
                                                 menuItem("Comments", tabName = "comment")
                                     )
                    ),
                    ####################End of Dashboard Sidebar##################
                    dashboardBody(#style = "overflow: auto",
                      tags$script('$(".sidebar-menu a[data-toggle=\'tabs\']").click(function(){window.scrollTo({top: 0});})'),
                      tags$script(HTML("$('body').addClass('fixed');")),
                      tags$style(HTML("
       .custom-text {
         color: black;
         font-size: 20px;
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
                                h2(strong("Motivation and Background")),
                                p("Welcome to this survey aimed at crowdsourcing 
                                expertise to map the multiverse of data processing 
                                and analysis decisions in network neuroscience 
                                of human cognition!",
                                br(), br(),
                                "Many of us agree that there is a need for methodological 
                                solutions that aim to bring transparency to the 
                                black box created by researchers' degrees of freedom. 
                                To describe the multitude of researchers' methodological 
                                choices, Gelman and Loken (2013) coined the term 
                                'garden of forking paths'. In every step of the 
                                study planning, data processing and analysis workflow, 
                                multiple defensible decisions and potential operations 
                                are available as choices. The established approach 
                                in science to date is still to select one specific 
                                but arbitrary workflow from which results are reported 
                                and conclusions are made about the phenomenon under 
                                study. Multiverse-type analyses 
                                (e.g., Steegen et al., 2016) have been proposed 
                                as an approach to open the black box around 
                                researchers' degrees of freedom. In a multiverse 
                                analysis approach, the decision nodes along the 
                                analysis pipeline and the defensible choices we 
                                can make are explicitly specified. These decision 
                                nodes are then used to generate the garden of forking 
                                paths, which contains all defensible combinations 
                                of decisions with their choices, and the analysis 
                                is performed on the entire array of specifications.",
                                br(), br(),
                                "But, 'the multiverse is a dangerous place' (Del 
                                Giudice and Gangestad, 2021). This is because its 
                                central idea is that the alternative choices contained 
                                in the multiverse are \"arbitrary\" and \"defensible\", 
                                i.e. they are equally \"reasonable\". The inclusion 
                                of decision nodes in the multiverse analysis that 
                                are mistakenly considered to be \"arbitrary\" will 
                                lead to combinatorial explosion and misleading 
                                interpretations of the multiverse of results.",
                                br(), br(),
                                "In the field of network neuroscience of human 
                                cognition, the decision space from the raw data 
                                to the statistical model testing a brain-behavior 
                                association is immense. We need to synthesize and 
                                systematize knowledge about defensible choices 
                                before we can explore how they affect our results.",
                                br(), br(),
                                "The goal of this project and associated survey 
                                is to crowdsource expertise for mapping the multiverse 
                                of data processing and analysis decisions in network 
                                neuroscience of human cognition.",
                                br(), br(),
                                "Thank you for participating in this project!",
                                br(), br(),
                                "As all contributors to this project will be co-authors 
                                on a community paper (see details in the next tab), 
                                this survey is not anonymous.", strong("Please enter 
                                your last name in the box below."), "Please do 
                                not use any special characters, just lower case 
                                letters, and just type your last name.", class = "custom-text"),
                                textInput("Expert_ID", "Last Name", value = "")
                        ),
                        tabItem(tabName = "person",
                                h2("Participant information"),
                                box(
                                  title = NULL,
                                  width = 12,
                                  solidHeader = TRUE,
                                  textInput(question$Code[1], question$Question[1]), # Name
                                  textInput(question$Code[2], question$Question[2]), # Country
                                  textInput(question$Code[3], question$Question[3]), # Affiliation
                                  # Position: (text, if "Other")
                                  checkboxGroupInput(question$Code[4], question$Question[4], choices = as.character(strsplit(question$Options[4], ";")[[1]])),
                                  textInput(question$Code[5], question$Question[5]),
                                  # Field of Study: (text, if "Other")
                                  selectInput(question$Code[6], question$Question[6], choices = as.character(strsplit(question$Options[6], ";")[[1]]), selected = NULL),
                                  textInput(question$Code[7], question$Question[7]),
                                  shinysurveys::numberInput(question$Code[8], question$Question[8], placeholder = NULL, min=0), # Years of Research experience
                                  # Previous Experience with Redoing studies, if, yes, describe broadly
                                  checkboxInput(question$Code[9], question$Question[9]),#, choices = as.character(strsplit(question$Options[9], ";")[[1]])),
                                  textInput(question$Code[10], question$Question[10]),
                                )
                        ),
                        
#####################################Do Your Own##############################################################
                        tabItem(tabName = "study",
                                h2(strong("Dummy page for original and redoing study information (Part 3 of the protocol)"))
                        ),
                        tabItem(tabName = "redo_desc",
                                h2(strong("Dummy page for descriptive questions (Part 4 Dimensions of comparison)?")),
                                p("Now, think of your most recent re-doing/replication activity (if available)."),
                                textInput("rep_description", "Please describe this re-doing actitivy briefly.",
                                          placeholder = "..."),
                                textInput("rep_label", "How would you call this kind of re-doing activity? (E.g. reproduction, direct replication, conceptual replication,...)",
                                          placeholder = "Conceptual replication, reproducitibility check,...")
                                
                        ),
                        tabItem(tabName = "rating_obj",
                                fluidRow(
                                h3(strong("Please indicate to which extend your re-doing activity deviates from the initial study across the different dimensions.")),
                                # radioGroupButtons(inputId = "rating_obj_input",
                                #                   label = desc_dims[["Dimension"]][1],
                                #                   choices = c("Not at all different", "Slighly different", "Substantially different", "Unknown/uncontrolled", "Not applicable"),
                                #                   direction="horizontal", justified = TRUE),
                                # radioGroupButtons(inputId = "rating_obj_input", 
                                #                   label = desc_dims[["Dimension"]][1],
                                #                   choiceNames = rep("", 5), choiceValues = 1:5,
                                #                   direction="horizontal", justified = TRUE)
                                  
                                shinysurveys::radioMatrixInput(
                                  "ratingmatrix1",
                                  responseItems= aspects_matrix, choices = options_matrix, .required=FALSE
                                ),
                                textInput("rep_dims", "If any relevant dimension was missed above, please specify which dimension you specifically changed or kept constant in your study.",
                                          placeholder = "..."),
                                ),
                                h2(strong("Click on the dimensions for a detailed description")),
                                fluidRow(
                                  do.call(accordion, c(list(id = "descr_accordion1", width=4),# ,open=FALSE),
                                                       lapply(1:4, function(i){
                                                         accordionItem(
                                                           title = desc_dims[['Dimension']][i], p(desc_dims[['Description']][i])#, solidHeader = FALSE
                                                         )
                                                       }))),
                                  do.call(accordion, c(list(id = "descr_accordion2", width=4),# ,open=FALSE),
                                                       lapply(5:8, function(i){
                                                         accordionItem(
                                                           title = desc_dims[['Dimension']][i], p(desc_dims[['Description']][i])#, solidHeader = FALSE
                                                         )
                                                       }))),
                                  do.call(accordion, c(list(id = "descr_accordion3", width=4),# ,open=FALSE),
                                                       lapply(9:11, function(i){
                                                         accordionItem(
                                                           title = desc_dims[['Dimension']][i], p(desc_dims[['Description']][i])#, solidHeader = FALSE
                                                         )
                                                       })))
                                )
                        ),
                        tabItem(tabName = "rating_exp",
                                h2(strong("Dummy page for rating the dimensions of comparison in terms of expected influence on outcome"))
                        ),
                        tabItem(tabName = "rating_intent",
                                h2(strong("Dummy page for rating the dimensions of comparison in terms of the intention/reason for differences ...?"))
                        ),
                        # tabItem(tabName = "exp_f",
                        #         h3("Below are brief descriptions of the decisions 
                        #         applied to graph-theoretic analyses of the whole 
                        #         brain functional connectome. These have all been 
                        #         made by the researchers contributing to the current 
                        #         literature and have been extracted through a systematic 
                        #         literature review and coding.  ", class = "custom-text"),
                        #         h3("Steps"),
                        #         DT::dataTableOutput("list_steps"),
                        #         h3("Options"),
                        #         DT::dataTableOutput("list_options")
                        # ),
                        
                        tabItem("comment",
                        h3("Thank you for your participation!"),
                        br(),
                        br(),
                                textInput("additional_info", "Here is enough space for additonal comments:", ""),
                                actionButton("end_survey", "End Survey and submit answers")
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
