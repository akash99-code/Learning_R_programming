library("shiny")

## UI APP
ui <- fluidPage(
  
  # App Title
  titlePanel("Faithful Waiting time"),
  
  # Sidebar layout with input and output definitions
  sidebarLayout(
    
    # Sidebar panel for inputs
    sidebarPanel ( 
      
      # Slider input
      sliderInput(inputId = "bins",
                  label = "No. of bins:",
                  min =1,
                  max=50,
                  value=30),
      ),
    
      # Main panel 
       mainPanel(
        plotOutput(outputId = "distplot")
        )
      
    
  )
  
)

## Server Logic
server <- function(input, output){
  
   output$distplot <- renderPlot({
     x<- faithful$waiting
     bins <- seq(min(x), max(x), length.out = input$bins+1)
     
     hist(x, breaks=bins, col = "#75AADB", border = "white",
          xlab = "Waiting time to next eruption (in mins)",
          main = "Histogram of waiting times")
   })
}

shinyApp(ui = ui, server=server)





###6383574958