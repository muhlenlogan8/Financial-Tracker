################################################################################

### This file houses the ui elements of the app

################################################################################


ui <- shinyUI({
  dashboardPage(
    dashboardHeader(title = "Financial Tracker"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Input File", tabName = "inputDataTab"),
        menuItem("Home Dashboard", tabName = "homeDashboardTab"),
        menuItem("Data Table", tabName = "dataTableTab")
      )
    ),
    dashboardBody(
      tabItems(
        tabItem("inputDataTab",
                fileInput("inputFile", "Input .xlsx File", accept = ".xlsx")
        ),
        tabItem("homeDashboardTab",
                fluidRow(
                  valueBoxOutput("currentBalance"),
                  valueBoxOutput("incomeToDate"),
                  valueBoxOutput("debitsToDate")
                )
        ),
        tabItem("dataTableTab",
                formattableOutput("formattableTable")
        )
      )
    )
  )
})