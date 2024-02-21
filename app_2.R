library(shiny)
library(ggplot2) # use mpg dataset in ggplot2
library(data.table)

dt <- as.data.table(mpg)
manufacturer_list <- dt[, unique(manufacturer)]

ui <- fluidPage(
  selectInput(inputId = "manufacturer",
              label = "Manufacturer",
              choices = manufacturer_list,
              selected = manufacturer_list[1]
  ),
  selectInput(inputId = "model",
              label = "Model",
              choices = NULL
  ),
  tableOutput("table")
)

server <- function(input, output, session) {
  
  filtered_models <- reactive({
    dt[manufacturer == input$manufacturer, unique(model)]
  })
  
  observeEvent(filtered_models(), {
    updateSelectizeInput(session, 'model', choices = c(filtered_models()), selected = filtered_models()[1])
  })
  
  filtered_mpg <- reactive({
    dt[manufacturer == input$manufacturer & model == input$model]
  })
  
  output$table <- renderTable(filtered_mpg())
  
}

shinyApp(ui, server)