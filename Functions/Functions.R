#####################
### App Functions ###
#####################

cleanData <- function(data) {
  data <- data %>%
    rename(
      "Date" = Processed.Date,
      "Transaction" = Description,
      "Type" = Credit.or.Debit
    ) %>%
    select("Date", "Transaction", "Type", "Amount") %>%
    # Convert Date to "M/D/YYYY" format
    mutate(
      Date = format(as.Date(Date, format = "%Y-%m-%d"), "%-m/%-d/%Y"),
      Transaction = sub(" \\*\\*\\d{4}", "", 
                        sub("^[A-Z ]+\\d+ \\d{2}/\\d{2}/\\d{2} \\d+\\s+(.*?)\\s+(?:CARD#|C#)", 
                            "\\1", Transaction, perl = TRUE), perl = TRUE)
    )
  
  return(data)
}

calculateTotals <- function(data) {
  incomes <- data %>% filter(Type == "Credit")
  debts <- data %>% filter(Type == "Debit")
  
  totalIncome <- sum(incomes$Amount, na.rm = TRUE)
  totalDebts <- sum(debts$Amount, na.rm = TRUE)
  netBalance <- totalIncome - totalDebts
  
  return(list(totalIncome = totalIncome, totalDebts = totalDebts, netBalance = netBalance))
}

summarizeByMonth <- function(data) {
  data <- data %>%
    mutate(Month = format(as.Date(Date, format = "%m/%d/%Y"), "%Y-%m")) %>%
    group_by(Month) %>%
    summarize(Income = sum(Amount[Type == "Credit"], na.rm = TRUE),
              Expenses = sum(Amount[Type == "Debit"], na.rm = TRUE)) %>%
    arrange(Month)
}

