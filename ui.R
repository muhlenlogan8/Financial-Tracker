###################
### UI Elements ###
###################

ui <- fluidPage(
  titlePanel("Finance Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload CSV", accept = ".csv"),
      helpText("Upload a CSV file"),
      downloadButton("downloadFile", "Download Dummy Data"),
      
      # Multi-select dropdown for selecting months
      uiOutput("monthDropdown"),
      
      # Radio buttons for chart selection
      radioButtons("chartType", "Select Chart Type:",
                   choices = c("Bar Chart", "Pie Chart", "Line Chart"),
                   selected = "Bar Chart")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Table", DTOutput("dataTable")),
        tabPanel("Charts", plotOutput("incomeExpensePlot")),
        tabPanel("Statistics", verbatimTextOutput("summaryStats"))
      )
    )
  )
)