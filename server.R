#######################
### Server Elements ###
#######################

server <- function(input, output, session) {
  # Reactive to store uploaded data
  uploadedData <- reactive({
    req(input$file)
    read.csv(input$file$datapath)
  })
  
  # Dynamic upload box
  output$uploadBox <- renderUI({
    if (is.null(input$file)) {
      div(class = "upload-box", 
          div(class = "file-input-wrapper",
              h3("Upload Your Financial Data"),
              fileInput("file", "Choose CSV File", accept = ".csv", 
                        placeholder = "No file selected"),
              p("Upload your financial data CSV file for analysis.")
          )
      )
    } else {
      NULL
    }
  })
  
  # Dynamic column mapping inputs
  output$columnMapping <- renderUI({
    req(uploadedData())
    colNames <- colnames(uploadedData())
    
    div(class = "column-mapping",
        h3("Map Columns"),
        selectInput("dateCol", "Select Date Column:", choices = colNames),
        selectInput("transactionCol", "Select Transaction Column:", choices = colNames),
        selectInput("typeCol", "Select Type Column:", choices = colNames),
        selectInput("amountCol", "Select Amount Column:", choices = colNames),
        fileInput("file", "Choose CSV File", accept = ".csv", 
                  placeholder = "Upload New File")
    )
  })
  
  # Table message
  output$tableMessage <- renderUI({
    if (is.null(input$file)) {
      div("Upload data for the table to be generated.", class = "table-message")
    } else {
      NULL
    }
  })
  
  # Render uploaded data table
  output$uploadedTable <- renderDT({
    req(uploadedData())
    datatable(
      uploadedData(),
      options = list(scrollX = TRUE, pageLength = 15)
    )
  })
}
