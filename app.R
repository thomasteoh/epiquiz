# -----
# Epiquiz: a shiny app to present flash cards online
# -----


# Load gsheet library to read google sheets
library(gsheet)

# Load data directly from the google sheets document
# A Google Sheets document must be previously created (it is adviseable to use one from a Google Forms output) and publicly shared
# Make sure to replace sheetaddress with the address of the sheet, as obtained from the publicly shareable link
# The structure of the sheet should include Theme Number, Question and Answer headings from which the data can be organised
df0 <- gsheet2tbl('docs.google.com/spreadsheets/d/'sheetaddress)

# Substitute LaTeX newlines for HTML newlines
df0$Answer <- gsub("\\n", "<br/>", df0$Answer)
df0$Question <- gsub("\\n", "<br/>", df0$Question)

# Randomise order of questions
df0 <- df0[sample(1:nrow(df0)),]

library(shiny)

# Define UI for application 
ui <- fluidPage(theme = "bootswatch.css", withMathJax(),
   
   # Application title
   titlePanel("Epidemiology study quiz for ANZCVS membership exam"),
   
   # Sidebar with a select input
    sidebarLayout(
       sidebarPanel(
         # Select input for meeting number
         selectInput("meeting", label = h3("Meeting number"), 
                     choices = as.list(levels(as.factor(df0$Theme.number))), selected = 1),
         # Checkbox to show answers and equations
         checkboxInput('showanswer', 'Show answers', FALSE),
         # Button to go to next question
         actionButton("do", "Next Question"),
         # Display the current question out of total questions
         textOutput("current")
       ),

      # Show a question and answer
      mainPanel(
        # Question
        h3("Question"),
        tags$p(uiOutput("question")),
        
        tags$hr(),
        
        # Answer
        h3("Answer"),
        tags$p(uiOutput("answer")),
        tags$p(uiOutput("equations")),
        tags$hr(),
        
        # Reference ID
        tags$aside(htmlOutput("refid")),
        tags$aside("Resources sourced and modified from Jaimie Hunnam's excellent flash cards")
      )
   )
)

# Define the server component of the shiny app
server <- function(input, output, session) {
  # A count of the current question number. Goes up when you press button
  qcount <- reactiveValues(count = 1)
   
  # Observing when the input has been activated
  # Upon clicking the button, it will increment by one. 
  # If it has hit the maximum number of questions, it will go back to the first question
  observeEvent(input$do, qcount$count <- (qcount$count %% sum(df0$Theme.number == input$meeting)) + 1)
  output$current <- renderText({paste(qcount$count, "/", sum(df0$Theme.number == input$meeting), sep = "")})
  # Question
  output$question <- renderUI({
    HTML(paste0(df0[df0$Theme.number == input$meeting,"Question"][qcount$count]))
    })
  # Hidden element with the answer
  output$answer <- renderUI({
    if (!input$showanswer) return()
    HTML(paste0(df0[df0$Theme.number == input$meeting, "Answer"][qcount$count]))
    })
  # Seperate one rendering equations
    output$equations <- renderUI({
    if (!input$showanswer) return()
    withMathJax(paste0(df0[df0$Theme.number == input$meeting, "Equations"][qcount$count]))
    })
  # Reference ID for backtracing corrections and errors
  # Going to be basing on meeting number and time of entry as they should be unique
  output$refid <- renderText({HTML(paste("If corrections are required for this question, <a href='mailto:epi@tteoh.com?subject=epiquiz [ID: ", df0[df0$Theme.number == input$meeting,"Theme.number"][qcount$count], "-", gsub(":", "", strsplit(df0[df0$Theme.number == input$meeting,"Timestamp"][qcount$count], " ")[[1]][2]), "]'>email Thomas</a> citing question ID: ", df0[df0$Theme.number == input$meeting,"Theme.number"][qcount$count], "-", gsub(":", "", strsplit(df0[df0$Theme.number == input$meeting,"Timestamp"][qcount$count], " ")[[1]][2]), sep = ""))})
}

# Run the application 
shinyApp(ui = ui, server = server)
