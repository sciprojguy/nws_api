library("geojsonio")
library("geojsonR")
library("rjson")
library("rgdal")

base.api <- "https://api.weather.gov"

#weather stations
stations.api <- paste(base.api, "/stations", sep = "")
stations.api
rjson::fromJSON(file = stations.api)

#point metdata - wrap this in a function that returns a dataframe?  or 
#just use the native GeoJSON fmt?
global.points.api <- paste(base.api, "/points/28,-82", sep = "")
points.results <- rjson::fromJSON(file = global.points.api)
points.results

#has URLs in it:
# $properties$forecast
# $properties$forecastGridData
# $properties$forecastHourly
# $properties$forecaseOffice
# $forecastZone
# $properties$observationStations
#and non-URL properties
# $properties$gridX
# $properties$gridY
# $properties$radarStation
# $properties$relativeLocation$geometry$coordinates (array of lon, lat)
# $properties$relativeLocation$bearing$unitCode
# $properties$relativeLocation$bearing$value
# $properties$relativeLocation$properties$city
# $properties$relativeLocation$properties$state
# $properties$relativeLocation$properties$timeZone
# $properties$relativeLocation$distance$unitCode
# $properties$relativeLocation$distance$value
#
# output df should be:
# df$latitude
# df$longitude
# df$radarStationCode
# df$timeZone
# df$cwa
# df$gridX
# df$gridY
# df$forecastURL
# df$hourlyForecastURL
# df$forecastGridDataURL
# df$observationStationsURL
# df$forecastOfficeURL
#
# or, in proper software dev style we can create objects for a lot of these:
#
# WeatherStation
# ForecastOffice
# SegmentedForecast
# HourlyForecast
# ForecastGridData
#
# and add methods that let us fetch data for different purposes - time series for
# station observations, spatial pixels for integrating stations etc on a ggmap,
# and the like.  the end game for this is the ability to recreate a local and
# regional weather map with weather stations, maybe grid boundaries and maybe
# kriged observations in between.
#
# for the moment, those can be elements in the data frame

#entry function - gets metadata for a lat/lon and generates a 1-row dataframe
points.meta = function(lat, lon) {
  
  points.api <- paste(base.api, "/points/", lat, ",", lon, sep = "")
  print(points.api)
  #print(global.points.api)
  points.raw.results <- rjson::fromJSON(file = points.api)
  #print(points.raw.results)
  class(points.raw.results)
  
  #okay, if we got results we need to package them up in the result dataframe
  #need to check for error and return early if there is one
  #also, need to set a class attribute for this
  
  #cautionary note - not all of the properties exist all the time, so 
  results <- data.frame(

    #longitude = lat,
    #latitude = lon,
    
    #gridX = points.raw.results$properties$gridX,
    #gridY = points.raw.results$properties$gridY,
    #cwa = points.raw.results$properties$cwa,
    
    #timeZone = points.raw.results$properties$timeZone,
    
    #radarStationCode = points.raw.results$properties$radarStation,
    
    #city = points.raw.results$relativeLocation$properties$city,
    #state = points.raw.results$relativeLocation$properties$state
    #,
    #distance = list(value = points.raw.results$relativeLocation$properties$distance$value, 
    #                units = points.raw.results$relativeLocation$properties$distance$unitCode),
    #bearing = list(value = points.raw.results$relativeLocation$properties$bearing$value, 
    #               units = points.raw.results$relativeLocation$properties$bearing$unitCode)
    
    #now the URLs - zone/area URLs
    #countyURL - points.raw.results$properties$county,
    #forecastZoneURL - points.raw.results$properties$forecastZone,
    #fireZoneURL - points.raw.results$properties$fireWeatherZone,
    
    #list of observation stations for this point
    #observationStationsURL = points.raw.results$observationStations
    
    #data URLs
  )

  points.raw.results
}

#27.9506,82.4572
tampa.results <- points.meta(28, -82)

#generates a n-row data frame containing prediction info
forecast = function(points.meta) {
  forecast.raw.results <- rjson::fromJSON(file = points.meta$forecastUrl)
  #now get forecast rows.  
}

#generates a n-row data frame containing prediction info
hourly.forecast = function(points.meta) {
  forecast.raw.results <- rjson::fromJSON(file = points.meta$hourlyForecastUrl)
  #now get forecast rows.  
}

#generates a n-row data.frame containing grid values
#grid.points.forecast = function(points.meta) {
# 
#}

#forecast.office = function(points.meta) {
# 
#}

#forecast zone: GPS points defining effective forecast zone
#forecast.zone = function(points.meta) {
#
#}

#fire zone: GPS points defining effective fire zone
#fire.zone = function(points.meta) {
#
#}

#forecast.stations = function(points.meta) {
# 
#}

#current.observations = function(points.meta) {
# 
#}

#historical.observations = function(points.meta) {
# 
#}

#station.current.observations = function(forecast.station) {
# 
#}

#station.historical.observations = function(forecast.station) {
# 
#}

#finally, we need functions to pull measurements out of station.current.observations
#as spatialpixelproperties, means we need library(sp) and library(ggmap)

#forecast - this one fails FROM_GeoJson but can be read with jsonlite::read_json()
forecast.url <- unlist(points.results$properties$forecast)
forecast.results <- rjson::fromJSON(file = forecast.url)

hourly.forecast.url <- unlist(points.results$properties$forecastHourly)
hourly.forecast.results <- rjson::fromJSON(file = hourly.forecast.url)

forecast.grid.url <- unlist(points.results$properties$forecastGridData)
grid.forecast.results <- rjson::fromJSON(file = forecast.grid.url)

county.url <- unlist(points.results$properties$county)
county.results <- rjson::fromJSON(file = county.url)

#stations for point

#station observations