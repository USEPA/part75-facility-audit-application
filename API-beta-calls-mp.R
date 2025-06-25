library(httr)
library(jsonlite)
library(tidyverse)
library(lubridate)

# API info
apiUrlBase <- "https://api.epa.gov/easey/beta"
apiKEY <- Sys.getenv("API_KEY")

########################################
############# MP API Calls #############
########################################

# Monitoring Plan urls
monitoringPlanConfigurationsUrl <- paste0(apiUrlBase,"/monitor-plan-mgmt/configurations?API_KEY=",apiKEY)

# monitoring plan configurations
get_monitoring_plan_configurations <- function(orisCodes){

  query <- list(orisCodes=paste0(orisCodes,collapse="|"))

  res = GET(monitoringPlanConfigurationsUrl, query = query)

  if ((res$status_code != 200) & (res$status_code != 304)){
    errorFrame <- fromJSON(rawToChar(res$content))
    stop(paste("Status Code",errorFrame$statusCode,"-",errorFrame$message))
  }

  monitoringPlanConfigurationsData <- fromJSON(rawToChar(res$content))$items

  monitoringPlanConfigurationsData
}

