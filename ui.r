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
library(shinyBS)

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
                                                 menuItem("Welcome", tabName = "about"),
                                                 #menuItem("Survey Information", tabName = "study"),
                                                 #menuItem("Participant information", tabName = "person"),
                                                 menuItem("General redoing Information", tabName = "originalstudy"),
                                                 menuItem("Changes in Dimensions", tabName = "ratings_change"),
                                                 menuItem("Changes in Results", tabName = "outcome_changes"),
                                                 # menuItem("Redoing activity", tabName = "redo",
                                                 #          menuSubItem("Original Study", tabName = "originalstudy"),
                                                 #          #menuSubItem("Description", tabName = "redo_desc"),
                                                 #          menuItem("Changes in Dimensions", tabName = "ratings_change"),
                                                 #          menuSubItem("Rating of expected difference", tabName = "rating_exp"),
                                                 #          menuSubItem("Rating of intentions", tabName = "rating_intent")
                                                 # ),
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
         font-size: 18px;
         text-align: justify;
         /* Add any other desired styles here */
       }
      
      [title]:hover::after {
        content: attr(title);
        position: absolute;
        font-size: 15px;
        top: -100%;
        left: 0;
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
                                  endeavors. As members of a study group within the",
                                  tags$a(href='https://www.meta-rep.uni-muenchen.de/index.html', "Meta-Rep project"),
                                  ", we are conducting a survey to examine the 
                                  generalizability of scientific studies and theories. 
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
                                  "In the following section, you will have the opportunity to describe the “redoing” study 
                                  you are planning, conducting, or have completed. We will ask for information 
                                  such as the DOI of the “redoing” study, DOI of the 
                                  original study, objectives, status, and the outcome of the study (if known).",br(),br(),
                                  "Finally, you will rate the differences between your “redoing” study and the original study,
                                  along the dimensions such as empirical data, participant population, independent variables and interventions, 
                                  dependent variables and outcome measures, procedures and settings, data analysis methods, and
                                  research question, hypotheses and theoretical frameworks.",br(), br(), 
                                  "Before you start with the questionnaire, we would like 
                                  to draw your attention to the following points about 
                                  the study listed below.",br(), br(),
                                  "Thank you very much for your participation,",br(), br(),
                                  "Prof. Dr. Felix Schönbrodt (LMU Munich) & the terminology 
                                  working group of the",
                                  tags$a(href='https://www.meta-rep.uni-muenchen.de/index.html', "Meta-Rep project"),br(), br(),
                                  "Under the following headings, you will find more detailed 
                                  information about the study and data protection information. 
                                  Simply click on the individual questions if you would like
                                  to receive further information.", class = "custom-text"),
                                br(),
                                accordion(
                                  id = "some_accordion_information",
                                  accordionItem(
                                    title = "Study and Data Protection Information for Online Survey",
                                    p("Under the following headings, you will find detailed explanations 
                                    of the study and data protection information. Simply click on the 
                                    individual questions if you would like further information.", class = "custom-text")
                                  ),
                                  accordionItem(
                                    title = "How is voluntariness and anonymity considered in the study?",
                                    p("Participation in the study is voluntary. You can end your participation 
                                    in this study at any time and without giving reasons, without any 
                                    disadvantages to you. The data collected as part of this study will be 
                                    treated strictly confidentially and used exclusively for scientific 
                                    research purposes. The results of the study will be published solely 
                                    in anonymized form, i.e., without the data being attributable to you 
                                    as a person.", class = "custom-text")
                                  ),
                                  accordionItem(
                                    title = "What data will be collected about me as part of the study?",
                                    p("During the survey, your responses will be recorded and stored as 
                                      numerical codes. The collected data relate to the purpose of the study. 
                                      Additionally, the survey program automatically collects so-called data 
                                      traces. These include, for example, the date and time of access to the 
                                      questionnaire as well as the total completion time. These data will be 
                                      irreversibly deleted by us before evaluation and will not be further 
                                      processed. We only use the answers you voluntarily provide during the 
                                      survey.", class = "custom-text")
                                  ),
                                  accordionItem(
                                    title = "Will personal data be collected about me?",
                                    p("Personal data refers to all information relating to an identified or 
                                      identifiable natural person. An identifiable natural person is one who 
                                      can be directly or indirectly identified, particularly by reference to 
                                      an identifier such as a name, an identification number, location data, 
                                      an online identifier, or one or more specific characteristics expressing 
                                      the physical, physiological, genetic, mental, economic, cultural, or social 
                                      identity of that natural person. In the context of our standardized online 
                                      survey, no personal data about you will be collected. We only store 
                                      information about the conference submission such as the DOI and title of 
                                      the project.", class = "custom-text")
                                  ),
                                  accordionItem(
                                    title = "How will my data be processed as part of the study?",
                                    p("The collection and processing of your study data will be carried out
                                      completely anonymized at the Katholische Universität Eichstätt-Ingolstadt 
                                      and LMU Munich.\n\nSubsequent provision of information, correction, deletion, 
                                      restriction of processing, or data portability is generally not possible 
                                      due to the anonymity of the data.", class="custom-text")
                                  ),
                                  accordionItem(
                                    title = "Who is responsible for processing my data?",
                                    p("Generally responsible for data processing is:",br(), br(),
                                      "Katholische Universität Eichstätt-Ingolstadt",br(), 
                                      "represented by: Prof. Dr. Michael Zehetleitner ",br(),
                                      "Ostenstraße 25 ",br(),
                                      "85072 Eichstätt",br(),
                                      "https://www.ku.de/",br(), br(),
                                      "For the security of processes, data processing, and compliance with 
                                    confidentiality and data protection within this study, Prof. Dr. Michael 
                                    Zehetleitner, is responsible for ensuring the procedures, data processing 
                                    and compliance with confidentiality and data protection in the context of 
                                    this study. The responsible data protection officer of the Katholische 
                                    Universität Eichstätt-Ingolstadt is Ziar Kabir (Email: info(at)sco-consult.de, 
                                    Tel.: 02224 98829-0).", class="custom-text")
                                  ),
                                  accordionItem(
                                    title = "For what purpose will my data be processed?",
                                    p("The purpose of the data processing is to analyze an online 
                                      survey conducted as a part of the DFG-funded collaborative 
                                      project",
                                      tags$a(href="https://www.meta-rep.uni-muenchen.de/index.html", 
                                             'META-REP: A Meta-scientific Programme to Analyse and Optimise 
                                             Replicability in the Behavioural, Social and Cognitive Sciences.'), 
                                      class="custom-text")),
                                  accordionItem(
                                    title = "On what legal basis are my data processed?",
                                    p("The legal basis for data processing is your consent.", class="custom-text")
                                  ),
                                  accordionItem(
                                    title = "How can I revoke my consent?",
                                    p("You can withdraw your consent to participate in this study at any time 
                                      and without giving reasons by closing the browser window. This will not 
                                      result in any disadvantages for you.", class="custom-text")
                                  ),
                                  accordionItem(
                                    title = "How long will my data be stored?",
                                    p("After the completion of the study, the data will be retained and accessible 
                                      for a period of ten years. Legal storage and deletion periods will be ensured. 
                                      If there is a determination to delete the data, the deletion will be 
                                      documented comprehensively after all deadlines have expired.", class="custom-text")
                                  ),
                                  accordionItem(
                                    title = "Will my data be shared or based on my data be published?",
                                    p("The data will be processed by our data processor. Data collection 
                                      is done via shinysurveys. The transmission of data is done with 
                                      end-to-end encryption and in accordance with the guidelines of the 
                                      EU General Data Protection Regulation (GDPR).",br(), br(),
                                      "As an ecclesiastical foundation under public law, the KU applies 
                                      the Church Data Protection Act (KDG) in accordance with Art. 91 GDPR, 
                                      which is closely modeled on the GDPR.",br(), br(),
                                      "We process personal data collected on the basis of consent in 
                                      accordance with Section 6(1)(b) KDG for scientific purposes. Your 
                                      consent is voluntary. Refusal or revocation of consent is not 
                                      associated with any disadvantages for you. You can revoke your 
                                      consent at any time in writing or by e-mail to the person responsible 
                                      for data processing, with the result that the processing of your 
                                      personal data will become unauthorized for the future. However, this 
                                      does not affect the lawfulness of the processing carried out on the 
                                      basis of the consent until the revocation. In accordance with the 
                                      Church Data Protection Act, you can request information from the KU 
                                      pursuant to Section 17 KDG about which personal data concerning you 
                                      is processed by the KU and request rectification/completion pursuant 
                                      to Section 18 KDG if the data is incorrect or incomplete.",br(), br(),
                                      "You can also request the erasure pursuant to Section 19 KDG or the 
                                      restriction of processing pursuant to Section 20 KDG of the personal 
                                      data concerning you or object to certain data processing pursuant to 
                                      Section 23 KDG. You also have the right to data portability in 
                                      accordance with Section 22 KDG. If you make use of the aforementioned 
                                      rights, the controller will check whether the legal requirements for 
                                      this are met. You also have the right to lodge a complaint with the 
                                      data protection supervisory authority (Gemeinsame Datenschutzaufsicht 
                                      der bayerischen (Erz-)Diözesen, Kapellenstr. 4, 80333 München). Your 
                                      personal data will not be processed for the purpose of automated 
                                      decision-making (including profiling).",br(), br(),
                                      "The final dataset with fully anonymized data may be made available to 
                                      other researchers upon request or published on a protected platform 
                                      for data archiving, documentation, and exchange. This procedure 
                                      corresponds to the",
                                      tags$a(href="https://www.dfg.de/resource/blob/172098/4ababf7a149da4247d018931587d76d6/guidelines-research-data-data.pdf",
                                             "recommendations of the German Research Foundation (DFG)"),
                                      " as well as the rules of good scientific practice and serves 
                                      transparency and verifiability of results.",br(), br(),
                                      "The results of this study may be published in a scientific journal or 
                                      presented at scientific conferences. Any publication will be in an 
                                      anonymised form, i.e. the data cannot be attributed to a specific person.",
                                      class="custom-text")
                                    ),
                                  accordionItem(
                                    title = "What rights do I have?",
                                    p("Participation in the survey can be terminated at any time; in the event 
                                      of termination during the survey, we will exclude the answers given up to 
                                      that point in the evaluation. You have the right to information, correction, 
                                      deletion, restriction, and objection to processing or data portability. 
                                      However, this is usually not possible due to the anonymity of the data.",br(), br(),
                                      "You have the right to withdraw your consent by closing the survey in your 
                                      browser window at any time. You have the right to request information from 
                                      us about the processing of data concerning you. This right to information 
                                      includes information about the purpose of data processing, the recipients of 
                                      the data, and the storage period.",br(), br(),
                                      "If necessary, please contact the following person to exercise your rights:",br(), br(),
                                      "Katholische Universität Eichstätt-Ingolstadt",br(),
                                      "represented by: Prof. Dr. Michael Zehetleitner",br(),
                                      "Ostenstraße 25",br(), 
                                      "85072 Eichstätt",br(), 
                                      "https://www.ku.de/",br(), br(),
                                      "If you believe that the processing of your data is not lawful, you have the 
                                      right to lodge a complaint with the supervisory authority for data protection. 
                                      You have the right to lodge a complaint with the data protection supervisory 
                                      authority of your federal state in the event of a breach of the European Union's 
                                      General Data Protection Regulation (EUDSGVO).", class="custom-text")
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
                        #tabItem(tabName="study", 
                        #        h2("Study Information"),
                        #        p("Dear Participant,",br(),br(),
                        #          "Thank you for participating in our survey. Before you begin, it is important 
                        #          to understand the purpose and structure of the information we are gathering. 
                        #          Your input will contribute to valuable research in the field of “redoing” 
                        #          studies and replication efforts.",br(),br(),
                        #          "At the outset, we will need your consent to proceed with the survey. This 
                        #          involves providing some basic information and agreeing to the terms outlined. 
                        #          We will be collecting data to analyze various dimensions of “redoing” studies, 
                        #          with a commitment to transparency and ethical standards.",br(),br(),
                        #          "In this section, you will have the opportunity to describe the “redoing” study 
                        #          you are planning, conducting, or have completed. We will ask for information 
                        #          such as the DOI of the “redoing” study, DOI of the 
                        #          original study, objectives, status, and the outcome of the study (if known).",br(),br(),
                        #          "Next, you will rate the differences between your “redoing” study and the original study,
                        #          along the dimensions such as empirical data, participant population, independent variables and interventions, 
                        #          dependent variables and outcome measures, procedures and settings, data analysis methods, and
                        #          research question, hypotheses and theoretical frameworks.
                        #          This will provide valuable insights into the replication process and its outcomes.
                        #          Thank you for your participation. Your input is instrumental in advancing our 
                        #          understanding of “redoing” studies and promoting transparency and rigor in research 
                        #          practices.", class="custom-text")
                        #),
                        # tabItem(tabName = "person",
                        #         h2("Participant information"),
                        #         box(
                        #           title = NULL,
                        #           width = 12,
                        #           solidHeader = TRUE,
                        #           textInput(question$Code[1], question$Question[1]), # Name
                        #           selectInput(question$Code[2], question$Question[2], choices = countryList, selected = NULL), # Country
                        #           #textInput(question$Code[2], question$Question[2]), # Country
                        #           textInput(question$Code[3], question$Question[3]), # Affiliation
                        #           # Position: (text, if "Other")
                        #           checkboxGroupInput(question$Code[4], question$Question[4], choices = as.character(strsplit(question$Options[4], ";")[[1]])),
                        #           textInput(question$Code[5], question$Question[5]),
                        #           # Field of Study: (text, if "Other")
                        #           selectInput(question$Code[6], question$Question[6], choices = as.character(strsplit(question$Options[6], ";")[[1]]), selected = NULL),
                        #           textInput(question$Code[7], question$Question[7]),
                        #           shinysurveys::numberInput(question$Code[8], question$Question[8], placeholder = NULL, min=0), # Years of Research experience
                        #           # Previous Experience with Redoing studies, if, yes, describe broadly
                        #           checkboxInput(question$Code[9], question$Question[9]),#, choices = as.character(strsplit(question$Options[9], ";")[[1]])),
                        #           textInput(question$Code[10], question$Question[10]),
                        #         )
                        # ),
                        
#####################################Do Your Own##############################################################
                        tabItem(tabName = "originalstudy",
                                h2(strong("Information about the original study")),
                                p("The following questions are about the original study, to wich your redoing actitivity refers to."),br(),
                                textInput("RedoDOI", "If available, provide the DOI for easy reference to your study (preregistration, preprint, article).", width = '100%'), # Name
                                textInput("OrigDOI", "Provide the DOI(s) for easy reference to the original work(s).", width = '100%'), # Name
                                textInput("OrigTitle", "If the DOI was not available, provide the title(s) of the original study", width = '100%'), # Name
                                textInput("Objective", "Briefly describe the main objectives or research questions of your redoing study.", width = '100%'), # Name
                                textInput("RedoingLabel", "Give a brief name of the redoing activity (such as replication, reproduction, generalization test, robustness check, etc.)", width = '100%'), # Name
                                selectInput("Status", "What is the current status of your redoing activity?",
                                            choices=c("Planning", "Ongoing", "Completed but not publicly available", "Completed with publicly available preprint", 
                                          "Completed with publicly available peer-reviewed article"), width = '100%')
                                
                        ),
                        # tabItem(tabName = "redo_desc",
                        #         h2(strong("Dummy page for descriptive questions (Part 4 Dimensions of comparison)?")),
                        #         p("Now, think of your most recent redoing/replication activity (if available)."),
                        #         textInput("rep_description", "Please describe this redoing actitivy briefly.",
                        #                   placeholder = "..."),
                        #         textInput("rep_label", "How would you call this kind of redoing activity? (E.g. reproduction, direct replication, conceptual replication,...)",
                        #                   placeholder = "Conceptual replication, reproducitibility check,...")
                        #         
                        # ),
                        tabItem(tabName = "ratings_change",
                                fluidRow(
                                h4(strong("Objective change")),
                                p("Please indicate to which extend your redoing activity deviates from the initial study across the different dimensions. (Hover over dimensions for detailed explanation.)", class="custom-text"),
                                shinysurveys::radioMatrixInput(
                                  "ratingmatrix_objchanges",
                                  responseItems= aspects_matrix_span, 
                                  choices = options_matrix, .required=FALSE
                                ),
                                # textInput("rep_dims", "If any relevant dimension was missed above, please specify which dimension you specifically changed or kept constant in your study.", placeholder = "..."),
                                # ),
                                
                                h4(strong("Expected impact of the change on the results")),
                                p("What is the expected impact that the change on the respective dimensions of the redoing study would have on the results of the study, relative to the original study? (Hover over dimensions for detailed explanation.)", class="custom-text"),
                                shinysurveys::radioMatrixInput(
                                  "ratingmatrix_expectations",
                                  responseItems= aspects_matrix_span, 
                                  choices = options_matrix_expectations, .required=FALSE
                                ),
                                h4(strong("Reasons for the change or lack of change")),
                                p("What was the reason that the redoing study was changed or kept the same along this dimension, relative to the original study? (Hover over dimensions for detailed explanation.)", class="custom-text"),
                                shinysurveys::radioMatrixInput(
                                  "ratingmatrix_intentions",
                                  responseItems= aspects_matrix_span, 
                                  choices = options_matrix_intentions, .required=FALSE
                                )
                                )
                        ),
                        tabItem(tabName = "outcome_changes",
                                h1(strong("NOTE: I think this was not thought to be part of the first (short) survey. We also have no wording for this provided by the other groups. We could either get feedback from them or leave this page completely!")),
                                h2(strong("Observed differences")),
                                p("This page is about the actual observed outcome of your redoing activity. If you have not yet conducted and analyzed the redoing study, please skip this page and go on to the end of the survey", class="custom-text"),
                                radioGroupButtons("observedchange", "To what extend did the results from your redoing study deviate from the results of the original study?",
                                                  choices=c("No difference at all", "Slight differences", "Substantial differences", "Unknown/uncontrolled")),
                                h4(strong("Suspected cause of difference in results")),
                                p("If there were differences in the results of your study compared to the original study, to what extent do you suspect that any changes in the dimensions were the cause of this? (Hover over dimensions for detailed explanation.)", class="custom-text"),
                                shinysurveys::radioMatrixInput(
                                  "ratingmatrix_cause_changes",
                                  responseItems= aspects_matrix_span,
                                  choices = options_matrix_causechanges, .required=FALSE
                                )

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
                                textAreaInput("additional_info", "Here is enough space for additonal comments:", "", width = '80%', height='40%'),
                        br(),
                        radioButtons("part_conf2",
                                     "Please confirm once again your initial consent for the 
                                     anonymized evaluation of the responses or revoke it.",
                                     choiceNames = list("I revoke my consent, please delete my data.", 
                                                      "I still agree with the evaluation of my responses."),
                                     choiceValues = list("No", "Yes"), selected = "No"),
                        
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
