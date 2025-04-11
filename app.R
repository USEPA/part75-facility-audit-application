# Shiny Dashboard

# Load required packages
library(shinydashboard)
library(shiny)

# Create shiny dashboard UI
ui <- dashboardPage(
  dashboardHeader(title = "Shiny Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Data Table", tabName = "dataTable", icon = icon("table")),
      menuItem("Plot", tabName = "plot", icon = icon("chart-bar"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dataTable",
              h2("Data Table"),
              tableOutput("dataTable")
      ),
      tabItem(tabName = "plot",
              h2("Plot"),
              plotOutput("plot")
      )
    )
  )
)
# Create shiny server
server <- function(input, output) {
  # Sample data
  data <- data.frame(
    x = rnorm(100),
    y = rnorm(100)
  )

  # Render data table
  output$dataTable <- renderTable({
    head(data)
  })

  # Render plot
  output$plot <- renderPlot({
    plot(data$x, data$y, main = "Scatter Plot", xlab = "X-axis", ylab = "Y-axis")
  })
}

