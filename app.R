# Shiny Dashboard

# Load required packages
library(shinydashboard)
library(shiny)
library(plotly)
library(DT)
library(dotenv)

# if there's a .env file, load it
if (file.exists(".env")) {
  load_dot_env(".env")
}

# Load API-calls.R file
source("API-beta-calls-fc.R")
source("API-beta-calls-mp.R")
source("API-beta-calls-em.R")

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
              h2("Facility List"),
              DT::DTOutput("facilityDataTable"),
              h2("Monitoring Plan"),
              # Pick an Oris Code to view
              numericInput("orisCode", "Select ORIS Code:", value = 3, min = 1, max = 880110, step = 1),
              # Search button
              actionButton("searchButton", "Search"),
              # Display facility name
              h3(textOutput("facilityNameDisplay")),
              # Data table output
              DT::DTOutput("monPlanDataTable")
      )
    )
  )
)
# Shiny server
server <- function(input, output) {

  opYear <- 2023 # set the operating year

  # Fetch the list of applicable facilities for the given operating year
  # reduce data to only include the columns of interest
  # remove duplicates
  # merge with state codes to get the state name
  applicableFacilities <- get_facilities_applicable(opYear) %>%
    select(facilityId,stateCode) %>%
    distinct() %>%
    left_join(get_state_codes(), by = c("stateCode" = "stateCode")) %>%
    select(facilityId,stateCode,stateName, epaRegion)

  # Render the facility data table
  output$facilityDataTable <- DT::renderDataTable({
    applicableFacilities
  }, filter = "top", rownames= FALSE,
  options = list(
    scrollX = TRUE, # Enable horizontal scrolling
    scrollY = "400px" # Set vertical scroll height
  ))

  # Observe changes in selected rows
  observeEvent(input$facilityDataTable_rows_selected, {
    selected_rows <- input$facilityDataTable_rows_selected

    # Now you can use the selected_rows vector to perform actions
    # For example, filter your data to show only selected rows:
    if (length(selected_rows) > 0) {
      selected_data <- applicableFacilities[selected_rows, ]
      print(selected_data)
      # Do something with selected_data
    } else {
      # Handle the case where no rows are selected
    }
  })

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
    output$monPlanDataTable <- DT::renderDataTable({
      monitorPlanData
    }, filter = "top",
    options = list(
      scrollX = TRUE, # Enable horizontal scrolling
      scrollY = "400px" # Set vertical scroll height
    ))
  })

}

# Run the application
shinyApp(ui = ui, server = server)
