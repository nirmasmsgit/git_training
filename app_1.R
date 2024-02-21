# TODO 
# ADD AN ALL OPTION AND CHANGE THE LINETYPE BY CATEGORY
# CHANGE THE CHOICES INPUT BASED ON THE DATA AND NOT A STATIC DATA 

library(shiny)
library(tidyverse)

ui <- fluidPage(
  h1("Trial One"),
  p("Some Description about our application")
  selectInput("category", "Select Category",
              choices = c("Ozone", "Solor.R", "Wind", "Temp")), 
  renderUI("text1")
  plotOutput("testing")
)

server <- function(input, output, session) {
  
  long <- as.data.frame.matrix(airquality) %>% 
    pivot_longer(cols = c("Ozone", "Solar.R", "Wind", "Temp"), 
                names_to = "category", values_to = "value") %>% 
    mutate(value = as.character(value))
  
  reactive <- reactive({
    long <- long %>% 
      filter(category == input$category)
  })
  
  output$text1 <- renderUI({
    h1(paste("Category Selected -", input$category))
  })
  
  output$testing <- renderPlot({
    ggplot(reactive) + 
      geom_line(aes(x = paste(Month, Day), y = value, 
                    color = category)) + 
      ggtitle("Ozone Data Time")
  })
  
}

shinyApp(ui, server)