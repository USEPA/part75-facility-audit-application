library(httr)
library(jsonlite)
library(tidyverse)
library(lubridate)

# API info
apiUrlBase <- "https://api.epa.gov/easey/beta"
apiKEY <- Sys.getenv("API_KEY")

########################################
############ MDM API Calls #############
########################################

# MDM urls
mdmStateCodeUrl <- paste0(apiUrlBase,"/master-data-mgmt/state-codes?API_KEY=",apiKEY)

get_state_codes <- function(){

  res = GET(mdmStateCodeUrl)

  if ((res$status_code != 200) & (res$status_code != 304)){
    errorFrame <- fromJSON(rawToChar(res$content))
    stop(paste("Status Code",errorFrame$statusCode,"-",errorFrame$message))
  }

  stateCodesData <- fromJSON(rawToChar(res$content))$items

  stateCodesData
}
