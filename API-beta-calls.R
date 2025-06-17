library(httr)
library(jsonlite)
library(tidyverse)
library(lubridate)
library(dotenv)

# if there's a .env file, load it
if (file.exists(".env")) {
  load_dot_env(".env")
}

# API info
apiUrlBase <- "https://api.epa.gov/easey/beta"
apiKEY <- Sys.getenv("API_KEY")


########################################
######## Facilities API Calls ##########
########################################

# Facilities urls
facilitiesAttributeApplicatableUrl <- paste0(apiUrlBase,"/facilities-mgmt/facilities/attributes/applicable?API_KEY=",apiKEY)
facilityURL <- paste0(apiUrlBase,"/facilities-mgmt/facilities")

# facilities applicable
get_facilities_applicable <- function(year){

  query <- list(year=year)

  res = GET(facilitiesAttributeApplicatableUrl, query = query)

  if ((res$status_code != 200) & (res$status_code != 304)){
    errorFrame <- fromJSON(rawToChar(res$content))
    stop(paste("Status Code",errorFrame$statusCode,"-",errorFrame$message))
  }

  facilitiesApplicableData <- fromJSON(rawToChar(res$content))$items

  facilitiesApplicableData
}

get_facility <- function(orisCode){

  facilityIdURL <- paste0(facilityURL,"/",orisCode,"?API_KEY=",apiKEY)

  res = GET(facilityIdURL)

  if ((res$status_code != 200) & (res$status_code != 304)){
    errorFrame <- fromJSON(rawToChar(res$content))
    stop(paste("Status Code",errorFrame$statusCode,"-",errorFrame$message))
  }

  facilityData <- fromJSON(rawToChar(res$content))

  facilityData
}



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
