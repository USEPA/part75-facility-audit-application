library(httr)
library(jsonlite)
library(tidyverse)
library(lubridate)

# API info
apiUrlBase <- "https://api.epa.gov/easey/beta"
apiKEY <- Sys.getenv("API_KEY")

########################################
######### Emissions API Calls ##########
########################################

# Emissions urls
emmissionsExportUrl <- paste0(apiUrlBase,"/emissions-mgmt/emissions/export?API_KEY=",apiKEY)

# emissions export
get_emissions_export <- function(monitorPlanId, year, quarter){

  query <- list(monitorPlanId=monitorPlanId, year=year, quarter=quarter)

  res = GET(emmissionsExportUrl, query = query)

  if ((res$status_code != 200) & (res$status_code != 304)){
    errorFrame <- fromJSON(rawToChar(res$content))
    stop(paste("Status Code",errorFrame$statusCode,"-",errorFrame$message))
  }

  emissionsExportData <- fromJSON(rawToChar(res$content))

  emissionsExportData
}
