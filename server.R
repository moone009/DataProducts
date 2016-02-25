
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(ggplot2)
library(DT)
library(shiny)

regression_model <- lm(price~table+depth+carat,diamonds)


shinyServer(function(input, output) {
  
  variable <- reactive({input$var_diamond})
  
  output$distPlot <- renderPlot({
    
    bins <- input$bins
    # draw the histogram with the specified number of bins
    hist(diamonds[,c(variable())], breaks = bins, col = input$histcolor, border = 'white')
    
  })
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- diamonds
    if (input$cut != "All") {
      data <- data[data$cut == input$cut,]
    }
    if (input$color != "All") {
      data <- data[data$color == input$color,]
    }
    if (input$clarity != "All") {
      data <- data[data$clarity == input$clarity,]
    }
    #if (input$color != "D") {
    #  data <- data[data$color %in% input$color,]
    #}
    data
  }))
  
  #output$iris <- DT::renderDataTable(iris, filter = 'top', options = list(pageLength = 5)) #autoWidth = TRUE

  
  
  # You can access the value of the widget with input$text, e.g.
  #output$value <- renderPrint({ input$text })
  
  carat_input <- reactive({as.numeric(input$carat)})
  depth_input <- reactive({as.numeric(input$depth)})
  table_input <- reactive({as.numeric(input$table)})
  
  model3 <- reactive({
    Y <- data.frame(Prediction = predict(regression_model,data.frame(carat = carat_input(),
                                                                     depth = depth_input(),
                                                                     table = table_input()
    )))
  })
                  
  
  output$model <- DT::renderDataTable(model3(), options=list(bLengthChange=0,bFilter=0,bInfo=0,bAutoWidth=0))
  
  diamond_listings <- reactive({
    subset(diamonds,price > as.numeric(model3()) - 200 &  price < as.numeric(model3()) + 200 )
  })
  output$diamond_listing_results <- DT::renderDataTable(diamond_listings())
  
})




