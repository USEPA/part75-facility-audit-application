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
monitoringPlanPlansExportUrl <- paste0(apiUrlBase,"/monitor-plan-mgmt/plans/export?API_KEY=",apiKEY)
monitoringPlanPlansUrl <- paste0(apiUrlBase,"/monitor-plan-mgmt/plans")
monitoringPlanLocationsUrl <- paste0(apiUrlBase,"/monitor-plan-mgmt/locations")

# monitoring plan configurations
# test case: get_monitoring_plan_configurations(orisCodes=c(3,5))
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

# monitoring plan export
# test case: get_monitoring_plan_export(planId="TWCORNEL5-C0E3879920A14159BAA98E03F1980A7A", reportedValuesOnly=TRUE)
get_monitoring_plan_export <- function(planId, reportedValuesOnly=NULL){

  query <- list(planId=planId)

  # If reportedValuesOnly is not NULL add it in the query
  if (!is.null(reportedValuesOnly)){
    query$reportedValuesOnly <- reportedValuesOnly
  }

  res = GET(monitoringPlanPlansExportUrl, query = query)

  if ((res$status_code != 200) & (res$status_code != 304)){
    errorFrame <- fromJSON(rawToChar(res$content))
    stop(paste("Status Code",errorFrame$statusCode,"-",errorFrame$message))
  }

  monitoringPlanExportData <- fromJSON(rawToChar(res$content))

  monitoringPlanExportData
}

# monitoring plan plans
# test case: get_monitoring_plan_plans(planId="TWCORNEL5-C0E3879920A14159BAA98E03F1980A7A")
get_monitoring_plan_plans <- function(planId){

  monitoringPlanPlansIdUrl <- paste0(monitoringPlanPlansUrl,"/",planId,"?API_KEY=",apiKEY)

  res = GET(monitoringPlanPlansIdUrl)

  if ((res$status_code != 200) & (res$status_code != 304)){
    errorFrame <- fromJSON(rawToChar(res$content))
    stop(paste("Status Code",errorFrame$statusCode,"-",errorFrame$message))
  }

  monitoringPlanPlansData <- fromJSON(rawToChar(res$content))

  monitoringPlanPlansData
}

# monitoring plan locations
# test case: get_monitoring_plan_locations(locId=5)
get_monitoring_plan_locations <- function(locId){

  monitoringPlanLocationsIdUrl <- paste0(monitoringPlanLocationsUrl,"/",locId,"?API_KEY=",apiKEY)

  res = GET(monitoringPlanLocationsIdUrl)

  if ((res$status_code != 200) & (res$status_code != 304)){
    errorFrame <- fromJSON(rawToChar(res$content))
    stop(paste("Status Code",errorFrame$statusCode,"-",errorFrame$message))
  }

  monitoringPlanLocationsData <- fromJSON(rawToChar(res$content))

  monitoringPlanLocationsData
}

# monitoring plan locations attributes
# test case: get_monitoring_plan_locations_attributes(locId=5)
get_monitoring_plan_locations_attributes <- function(locId){

  monitoringPlanLocationsIdUrl <- paste0(monitoringPlanLocationsUrl,"/",locId,"/attributes?API_KEY=",apiKEY)

  res = GET(monitoringPlanLocationsIdUrl)

  if ((res$status_code != 200) & (res$status_code != 304)){
    errorFrame <- fromJSON(rawToChar(res$content))
    stop(paste("Status Code",errorFrame$statusCode,"-",errorFrame$message))
  }

  monitoringPlanLocationsData <- fromJSON(rawToChar(res$content))$items

  monitoringPlanLocationsData
}

# monitoring plan locations unit controls
# test case: get_monitoring_plan_locations_unit_controls(locId=5, orisCode=3)
get_monitoring_plan_locations_unit_controls <- function(locId,orisCode){

  monitoringPlanLocationsIdUrl <- paste0(monitoringPlanLocationsUrl,"/",locId,"/units/",orisCode,"/unit-controls?API_KEY=",apiKEY)

  res = GET(monitoringPlanLocationsIdUrl)

  if ((res$status_code != 200) & (res$status_code != 304)){
    errorFrame <- fromJSON(rawToChar(res$content))
    stop(paste("Status Code",errorFrame$statusCode,"-",errorFrame$message))
  }

  monitoringPlanLocationsData <- fromJSON(rawToChar(res$content))$items

  monitoringPlanLocationsData
}

# monitoring plan locations unit fuels
# test case: get_monitoring_plan_locations_unit_fuels(locId=5, orisCode=3)
get_monitoring_plan_locations_unit_fuels <- function(locId,orisCode){

  monitoringPlanLocationsIdUrl <- paste0(monitoringPlanLocationsUrl,"/",locId,"/units/",orisCode,"/unit-fuels?API_KEY=",apiKEY)

  res = GET(monitoringPlanLocationsIdUrl)

  if ((res$status_code != 200) & (res$status_code != 304)){
    errorFrame <- fromJSON(rawToChar(res$content))
    stop(paste("Status Code",errorFrame$statusCode,"-",errorFrame$message))
  }

  monitoringPlanLocationsData <- fromJSON(rawToChar(res$content))$items

  monitoringPlanLocationsData
}

# monitoring plan locations methods
# test case: get_monitoring_plan_locations_methods(locId=5)
get_monitoring_plan_locations_methods <- function(locId){

  monitoringPlanLocationsIdUrl <- paste0(monitoringPlanLocationsUrl,"/",locId,"/methods?API_KEY=",apiKEY)

  res = GET(monitoringPlanLocationsIdUrl)

  if ((res$status_code != 200) & (res$status_code != 304)){
    errorFrame <- fromJSON(rawToChar(res$content))
    stop(paste("Status Code",errorFrame$statusCode,"-",errorFrame$message))
  }

  monitoringPlanLocationsData <- fromJSON(rawToChar(res$content))$items

  monitoringPlanLocationsData
}

