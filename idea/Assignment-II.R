library("tidyverse")
library("sf")
library("viridis")

india_states_sf <- read_sf("IND_adm1/IND_adm1.shp")

ggplot(india_states_sf)+
  geom_sf()

names(india_states_sf)
india_states_sf$NAME_1


india_vaccination <- read_csv("India_Vaccination_Data.csv")[1:3]
india_vaccination

india_activeCases <- read_csv("India_ActiveCases_Data.csv")[1:3]
india_activeCases


merged_data <- merge(india_states_sf, select(india_vaccination, -Name), by.x="ID_1", by.y="ID")
merged_data

merged_data <- merge(merged_data, select(india_activeCases, -NAME), by.x="ID_1", by.y="ID")
merged_data




ggplot(merged_data)+
  geom_sf(aes(fill=vaccination))+
  geom_point(
    aes(size = Active_Cases, geometry=geometry),
    stat="sf_coordinates",alpha=0.5,
    color="#FF0000"
  )+ 
  scale_fill_viridis(begin=0.2, end=.5, direction=1, option = "turbo")


  



