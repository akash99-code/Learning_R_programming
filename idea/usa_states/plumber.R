library("tidyverse")
library("sf")
library("plumber")


#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg="") {
  list(msg = paste0("The message is: '", msg, "'"))
}

#* Plot a histogram
#* @serializer png
#* @get /plot
function() {
  rand <- rnorm(100)
  hist(rand)
}

#* Chorpleth USA Regions - Insurance Data
#* @serializer svg
#* @get /plotUsaRegionsSvg
#plotUsaRegionsSvgR <-
function() {
  us_regions <- read_sf("../cb_2018_us_region_500k/cb_2018_us_region_500k.shp")
  insurance_data <- read_csv("./insurance.csv")
  insurance_data_regions <- insurance_data %>%
    group_by(region)  %>%
    summarize(regionsum = sum(expenses))
  insurance_data_regions$REGIONCE <- c(1,2,3,4)
  merged_data <- merge(us_regions, insurance_data_regions, by.x="REGIONCE", by.y="REGIONCE")
  merged_data$regionsum_prop <- (merged_data$regionsum)/ sum(merged_data$regionsum)
  
  plotUSaRegionsSvg <- ggplot(merged_data) +
    geom_sf(aes(fill=regionsum_prop ),size=0.09) +
    coord_sf(
      xlim = c(-130, -60),
      ylim = c(20, 50)
    )
  print(plotUSaRegionsSvg)
}

#* Chorpleth USA Regions - Insurance Data
#* @serializer jpeg
#* @get /plotUsaRegionsJpeg
function() {
  us_regions <- read_sf("../../cb_2018_us_region_500k/cb_2018_us_region_500k.shp")
  insurance_data <- read_csv("../insurance.csv")
  insurance_data_regions <- insurance_data %>%
    group_by(region)  %>%
    summarize(regionsum = sum(expenses))
  insurance_data_regions$REGIONCE <- c(1,2,3,4)
  merged_data <- merge(us_regions, insurance_data_regions, by.x="REGIONCE", by.y="REGIONCE")
  merged_data$regionsum_prop <- (merged_data$regionsum)/ sum(merged_data$regionsum)
  
  plotUSaRegions <- ggplot(merged_data) +
    geom_sf(aes(fill=regionsum_prop ),size=0.09) +
    coord_sf(
      xlim = c(-130, -60),
      ylim = c(20, 50)
    )
  ##ggsave("insurance_usa_regions.jpg")
  print(plotUSaRegions)
}


#* Chorpleth USA States - Covid Data
#* @serializer svg
#* @get /plotUsaStatesSvg
#testUSaStates <- function() {
function() {
  ##https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.html
  us_states_sf <- read_sf("./Choropleth/Usa_States/cb_2018_us_state_500k.shp")
  us_states_sf_48 <- us_states_sf %>%
    filter(!(NAME %in% c("Alaska", "District of Columbia", "Hawaii", "Puerto Rico")))
  
  ggplot(data = us_states_sf_48) +
    geom_sf()
  ## R-Value USA States
  usa_states_covid_Data <-  read_csv("./Choropleth/Usa_States/Covid-19 _USA_States_RValue.csv")
  
  merged_data <- merge(us_states_sf_48, usa_states_covid_Data, by.x="NAME", by.y="State")
  #merged_data
  
  ####  Vaccination Status - USA Status
  us_vaccine_data <- read_csv("./Choropleth/Usa_States/Vaccinated_Status_USA.csv")
  head(us_vaccine_data)
  vaccine_data <- us_vaccine_data %>% select(Province_State,People_Partially_Vaccinated,People_Fully_Vaccinated)
  vaccine_data
  ##### Merge Vaciine Data with Spatial Data + R-Value Data
  merged_data2 <- merge(merged_data,vaccine_data,by.x="NAME",by.y="Province_State")
  
  ###  Plot Layerd Map
  ###  1. USA States Map
  #### 2. Fill States with Vaccination Data
  #### 3. Bubbles corresponding to R Value
  plotUsaStatesSvg <- ggplot(data=merged_data2) +
    geom_sf(aes(fill = People_Fully_Vaccinated)) +
    geom_point(
      aes(size = R_Value, geometry = geometry),
      stat = "sf_coordinates"
    ) +
    theme(legend.position = "bottom") +
    coord_sf(
      xlim = c(-130, -60),
      ylim = c(20, 50)
    )
  print(plotUsaStatesSvg)
}
