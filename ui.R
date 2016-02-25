
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)

shinyUI(navbarPage("Diamond Explorer!",
                   tabPanel("Documentation",
                            h2("Diamonds Dataset"),
                            hr(),
                            h3("Description"),
                            helpText("A dataset containing the prices and other attributes of almost 54,000 diamonds."),
                            h3("Format"),
                            
                            p("A data frame with 10 variables."),
                            
                            p("price: price in US dollars (326 18,823)"),
                            p("carat: weight of the diamond (0.2–5.01)"),
                            p("cut: quality of the cut (Fair, Good, Very Good, Premium, Ideal)"),
                            p("color: diamond colour, from J (worst) to D (best)"),
                            p("clarity: a measurement of how clear the diamond is (I1 (worst), SI1, SI2, VS1, VS2, VVS1, VVS2, IF (best))"),
                            p("x: length in mm (0–10.74)"),
                            p("y: width in mm (0–58.9)"),
                            p("z: depth in mm (0–31.8)"),
                            p("depth: total depth percentage"),
                            p("table: width of top of diamond relative to widest point"),
                            
                            h3("Dashboard Tutorial"),
                            helpText("The summary tab provides the user to view different histograms of the numerical data in the diamonds dataset and it also allows the user to query into the data."),
                            helpText("The diamond finder outputs the predicted diamond value based upon user inputs and provides them with a list of diamonds with a $200 price range.")
                            
                   ),
                   tabPanel("Summary",
                            
                            # Sidebar with a slider input for number of bins
                            sidebarLayout(
                              sidebarPanel(
                                fluidRow(
                                  column(3.5,
                                         selectInput("var_diamond",
                                                     "Diamond:",
                                                     c('carat','depth','price','table','x','y','z')))),
                                sliderInput("bins",
                                            "Number of bins:",
                                            min = 1,
                                            max = 50,
                                            value = 30),
                                
                                radioButtons("histcolor", label = h3("Histogram Colors"), 
                                                        choices = list("Red" = "red", "Green" = "green","Blue"="blue"),
                                                        selected = "red"),
                                
                                fluidRow(
                                  column(3.5,
                                         selectInput("cut",
                                                     "Cut:",
                                                     c("All",
                                                       unique(as.character(diamonds$cut))))
                                  ),
                                  column(3.5,
                                         selectInput("color",
                                                     "Color:",
                                                     c("All",
                                                       unique(as.character(diamonds$color))))
                                  ),
                                  column(3.5,
                                         selectInput("clarity",
                                                     "Clarity:",
                                                     c("All",
                                                       unique(as.character(diamonds$clarity))))
                                  )
                                )
                                
                              ),
                              
                              # Show a plot of the generated distribution
                              mainPanel(
                                plotOutput("distPlot"),
                                DT::dataTableOutput("table")
                              )
                            )
                   ),
              
                   tabPanel("Diamond Finder",
                            sidebarPanel(         
                              #textInput("text", label = h3("Text input"), value = "Enter text..."),
                              sliderInput("carat", "Carat:", min = 0, max = 6, value = 0.5, step= 0.1),
                              sliderInput("table", "Table:", min=0, max=100, value=50),
                              sliderInput("depth", "depth:", min=0, max=100, value=50)
                            ),
                            mainPanel(
                              DT::dataTableOutput("model"),
                              tabsetPanel( tabPanel('Diamonds with in 200 + or - range of prediction',
                                                    DT::dataTableOutput("diamond_listing_results")))
                              
                            )
                   )
                   
                   
                   
                   
                   
))
