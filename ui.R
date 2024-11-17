###################
### UI Elements ###
###################

ui <- fluidPage(
  theme = shinytheme("spacelab"), # Theme for the app theme
  
  # Include custom CSS
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  
  # Title
  h1("Financial Tracker", class = "title"),
  
  # Tab navigation bar
  tabsetPanel(
    id = "tabs",
    type = "tabs",
    tabPanel(
      "Data",
      uiOutput("uploadBox"),
      uiOutput("columnMapping"),
      fluidRow(
        column(12,
               div(class = "table-box",
                   h3("Uploaded Data Preview", style = "text-align: center; margin-bottom: 20px;"),
                   uiOutput("tableMessage"), # Message for table
                   DTOutput("uploadedTable")
               )
        )
      )
    ),
    tabPanel(
      "Graphs",
      div(class = "content-box", h3("Graphs Section (Coming Soon!)"))
    ),
    tabPanel(
      "Analytics",
      div(class = "content-box", h3("Analytics Section (Coming Soon!)"))
    )
  )
)
