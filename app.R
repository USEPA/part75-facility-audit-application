# Shiny Dashboard

# Load required packages
library(shinydashboard)
library(shiny)
library(plotly)
library(DT)

# Load API-calls.R file
source("API-beta-calls.R")

# Function to check for errors and warnings
check <- function(expression){
  tryCatch(
    expr = {
      expression
    },
    error = function(e){
      # return error message
      message(paste("Error:", e$message))
    },

    warning = function(w){
      # return warning message
      message(paste("Warning:", w$message))
    },

    finally = {
    }
  )
}

# Shiny dashboard UI
ui <- dashboardPage(
  dashboardHeader(title = "Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Monitor Plan Table", tabName = "dataTable", icon = icon("table"))
    )
  ),
  dashboardBody(
    includeCSS("www/styles.css"),
    tabItems(
      tabItem(tabName = "dataTable",
              h2("Monitoring Plan"),
              # Pick an Oris Code to view
              numericInput("orisCode", "Select ORIS Code:", value = 3, min = 1, max = 880110, step = 1),
              # Search button
              actionButton("searchButton", "Search"),
              # Display facility name
              h3(textOutput("facilityNameDisplay")),
              # Data table output
              DT::DTOutput("dataTable")
      )
    )
  )
)
# Shiny server
server <- function(input, output) {

  monitorPlanData <- data.frame()  # Initialize an empty data frame for monitor plan data

  # When the search button is clicked, fetch the monitoring plan data
  observeEvent(input$searchButton, {

    req(input$orisCode)  # Ensure ORIS code is selected

    # Check if the ORIS code is valid
    response <- check(get_facility(input$orisCode))

    # If the response is NULL, show an error notification
    if (is.null(response)) {
      showNotification("Invalid ORIS Code. Please try again.", type = "error")
      return()
    }

    # Fetch facility data and monitoring plan configurations
    facilityBasicData <- get_facility(input$orisCode)

    facilityNameStr <- paste0(facilityBasicData$facilityName, " (", facilityBasicData$facilityId, ")")

    output$facilityNameDisplay <- renderText({
      facilityNameStr
    })

    monitorPlanData <<- get_monitoring_plan_configurations(c(input$orisCode))

    # Render data table
    output$dataTable <- DT::renderDataTable({
      monitorPlanData
    },
    options = list(
      scrollX = TRUE, # Enable horizontal scrolling
      scrollY = "400px" # Set vertical scroll height
    ))
  })

}

# Run the application
shinyApp(ui = ui, server = server)
