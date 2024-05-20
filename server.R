################################################################################

### This file houses the server elements of the app

################################################################################

server <- function(input, output, session) {
  output$currentBalance <- renderValueBox({
    valueBox(
      value = 100,
      subtitle = "Current Balance",
      icon = icon("dollar-sign"),
      color = "blue"
    )
  })
  output$incomeToDate <- renderValueBox({
    valueBox(
      value = 100,
      subtitle = "Income to Date",
      icon = icon("money-bill"),
      color = "green"
    )
  })
  output$debitsToDate <- renderValueBox({
    valueBox(
      value = 100,
      subtitle = "Debits to Date",
      icon = icon("credit-card"),
      color = "red"
    )
  })
  
  output$formattableTable <- renderFormattable({formattable(iris)})
}