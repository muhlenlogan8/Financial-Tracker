#######################
### Server Elements ###
#######################

server <- function(input, output, session) {
  # Load and process data
  data <- reactive({
    req(input$file)
    read.csv(input$file$datapath) %>% 
      cleanData()
  })
  
  # Generate unique months for the multi-select dropdown
  output$monthDropdown <- renderUI({
    req(data())
    monthChoices <- unique(format(as.Date(data()$Date, format = "%m/%d/%y"), "%Y-%m"))
    selectInput("selectedMonth", "Select Month(s):", 
                choices = c("All", monthChoices), 
                selected = "All", 
                multiple = TRUE)
  })
  
  # Provide dummy data to download
  output$downloadFile <- downloadHandler(
    filename = function() {
      paste("DummyData", ".csv", sep = "")
    },
    content = function(file) {
      downloadData <- read.csv("Data/DummyData.csv")
      write.csv(downloadData, file, row.names = FALSE)
    }
  )
  
  # Render data table with month filtering
  output$dataTable <- renderDT({
    req(data())
    filteredData <- data()
    
    # Filter data if specific months are selected
    if (!("All" %in% input$selectedMonth)) {
      filteredData <- filteredData %>% 
        filter(format(as.Date(Date, format = "%m/%d/%y"), "%Y-%m") %in% input$selectedMonth)
    }
    
    datatable(filteredData)
  })
  
  # Render income/expense plot with month filtering
  output$incomeExpensePlot <- renderPlot({
    req(data())
    summary <- summarizeByMonth(data())
    
    # Filter data by selected months
    if (!("All" %in% input$selectedMonth)) {
      summary <- summary %>% filter(Month %in% input$selectedMonth)
    }
    
    # Plot based on selected chart type
    if (input$chartType == "Bar Chart") {
      ggplot(summary, aes(x = Month)) +
        geom_col(aes(y = Income), fill = "green") +
        geom_col(aes(y = Expenses), fill = "red") +
        labs(title = "Monthly Income and Expenses", x = "Month", y = "Amount")
      
    } else if (input$chartType == "Pie Chart") {
      income <- sum(summary$Income, na.rm = TRUE)
      expenses <- sum(summary$Expenses, na.rm = TRUE)
      pieData <- data.frame(
        Category = c("Income", "Expenses"),
        Amount = c(income, expenses)
      )
      
      ggplot(pieData, aes(x = "", y = Amount, fill = Category)) +
        geom_bar(stat = "identity", width = 1) +
        coord_polar("y") +
        labs(title = "Income vs. Expenses")
      
    } else if (input$chartType == "Line Chart") {
      ggplot(summary, aes(x = Month)) +
        geom_line(aes(y = Income, color = "Income", group = 1)) +
        geom_line(aes(y = Expenses, color = "Expenses", group = 1)) +
        labs(title = "Monthly Income and Expenses",
             x = "Month", y = "Amount") +
        scale_color_manual(values = c("Income" = "green", "Expenses" = "red")) +
        theme_minimal()
    }
  })
  
  # Display summary stats with month filtering
  output$summaryStats <- renderPrint({
    req(data())
    filteredData <- data()
    
    # Filter by selected months
    if (!("All" %in% input$selectedMonth)) {
      filteredData <- filteredData %>% 
        filter(format(as.Date(Date, format = "%m/%d/%y"), "%Y-%m") %in% input$selectedMonth)
    }
    
    totals <- calculateTotals(filteredData)
    cat("Total Income: ", totals$totalIncome, "\n")
    cat("Total Expenses: ", totals$totalDebts, "\n")
    cat("Net Balance: ", totals$netBalance, "\n")
  })
}
