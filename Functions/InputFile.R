################################################################################

### This file houses functions related to the app's input file

################################################################################


readInputFile <- function() {
  data <- read_excel("Data/TestFinancialData.xlsx")
  return(data)
}