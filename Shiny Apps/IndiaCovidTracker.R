library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # App title
  titlePanel("India Covid Tracker"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    library("sf")
    library("tidyverse")
    india_states <- read_sf("../R Scripts/IND_adm1/IND_adm1.shp")
    india_covid_data <- read_csv("../datasets/India_ActiveCases_Data.csv")
    merged_geo_covid_data <- merge(india_states,india_covid_data,by.x="NAME_1",by.y="NAME")
    
    ggplot(data=merged_geo_covid_data) +
      geom_sf(aes(fill = Active_Cases)) +
      geom_point(
        aes(size = Vaccine_sec_dose, geometry = geometry),
        stat = "sf_coordinates"
      ) +
      theme(legend.position = "bottom")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
