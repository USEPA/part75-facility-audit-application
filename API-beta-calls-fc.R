library(httr)
library(jsonlite)
library(tidyverse)
library(lubridate)

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
