library("sf")
library("tidyverse")

usa_states_covid_dat <- read_csv("usa_states/Covid-19 _USA_States_RValue.csv")
usa_states_sf <- read_sf("cb_2018_us_state_500k/cb_2018_us_state_500k.shp")

ggplot(usa_states_sf) +
  geom_sf()

names(usa_states_covid_dat)
names(usa_states_sf)

merged_data <- merge(usa_states_sf, usa_states_covid_dat, by.x="NAME", by.y="State")
merged_data

ggplot(merged_data) +
  geom_sf(aes(fill = NAME ))


# virids package for the color palette
library(viridis)

ggplot(merged_data) +
  geom_sf(aes(fill = NAME)) +
  scale_color_viridis(option="magma")


# layered maps
ggplot(merged_data)+
  geom_sf(aes(fill =NAME))+
  geom_point(
    aes(size = R_Value, geometry=geometry),
    stat="sf_coordinates"
  ) +
  scale_color_viridis_c(option = "C") +
  theme(legend.position = "bottom")

###
us_vaccine_data <- read_csv("usa_states/Vaccinated_Status_USA.csv")
head(us_vaccine_data)
names(us_vaccine_data)

min(us_vaccine_data$People_Partially_Vaccinated)
max(us_vaccine_data$People_Partially_Vaccinated)
us_vaccine_data$Partial_pop <- (us_vaccine_data$People_Partially_Vaccinated)/ min(us_vaccine_data$People_Partially_Vaccinated)
min(us_vaccine_data$Partial_pop)
max(us_vaccine_data$Partial_pop)



names(us_vaccine_data)
names(merged_data)

vaccine_data <- us_vaccine_data %>%
  select(Province_State, People_Partially_Vaccinated, People_Fully_Vaccinated)

merged_data2 <- merge(merged_data, vaccine_data, by.x="NAME", by.y="Province_State")
merged_data2



ggplot(merged_data2)+
  geom_sf(aes(fill =People_Fully_Vaccinated)) +
  geom_point(aes(size = R_Value, geometry=geometry),
             stat="sf_coordinates") +
  scale_color_viridis_c(option = "C") +
  theme(legend.position = "bottom")
