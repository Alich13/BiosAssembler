#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
options(shiny.maxRequestSize = 50*1024^2)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
    theme=shinytheme("united"),# returns URL of a shiny theme
    #themeSelector(),
    navbarPage("clustering analysis",
        id="nav",
#tab0
tabPanel("about ", value="about ", id="0", 
         sidebarLayout(
             sidebarPanel(
            
            img(src = "kmeans.png", height = 140, width = 400)    
                 
                 
             ),
         
         mainPanel(
         p("This app allows you to  perform  basic clustering analysis , by implementing the kmeans clustering algorithm.\n 
        you can start by uploding your dataset or choosing one of the availble datasets in Data panel.",
         style = "font-family: 'times'; font-si16pt"),
         br(),
         strong("supporting documentation can be found "),a("here", href="doc.html"),
         br(),
         br(),
         br(),
         actionButton("start", "start", value=FALSE),
         hr(),
         hr(),
         img(src = "kmeans2.png", height = 500, width = 1000)  
         )
         )
        ),        
#tab1        
tabPanel("Data", value="Data", id="1",
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("select", h3("Select the  dataset"), 
                        choices = list("Iris", "mtcars","cars" ), selected = 1),
            tags$hr(),        
            uiOutput("view3"),
            
            fileInput("file", label = h3("File input")),
            helpText("max. file size is 30MB"),
            helpText("Select the read.table parameters below"),
            checkboxInput(inputId = 'header', label = 'Header', value = TRUE),
            checkboxInput(inputId = "stringAsFactors", "stringAsFactors", FALSE),
            radioButtons(inputId = 'sep', label = 'Separator', 
                         choices = c(Comma=',',Semicolon=';',Tab='\t', Space=''),   
                         selected = ','),
            hr(),
            
            fluidRow(column(4, verbatimTextOutput("value"))), 
            actionButton("submit", "submit", value=FALSE)
            
            
        ),

        
        mainPanel(
            tabsetPanel(
                tabPanel("Dataset", tableOutput("view")),
                tabPanel("Summary Stats", verbatimTextOutput("summary")),
                tabPanel("plots", plotOutput("plots"))
               
            ),
            
            tabsetPanel(
            tabPanel("raw data" ,     fluidRow(column(4, verbatimTextOutput("value1")))),
            tabPanel("pocessed data" ,     fluidRow(column(4, verbatimTextOutput("value2"))))
           #uiOutput("tb") #to plot the uploaded dataset
            )
     
        )
    )
),

#tab 2
tabPanel("Analysis ", value="Analysis", id ="2",
         sidebarLayout(
             sidebarPanel(
         h3("Kmeans  clustering"),
         
         sliderInput("n", "Select no. of cluster ", min = 2, max = 10, value=3),
         tags$hr(),
         helpText("you can switch the number of culusters and push the run button to see changes "),
         actionButton("R1", "Run analysis", value=FALSE),
         
         checkboxInput("val2","show heatmap", FALSE),
         tags$hr(),
         #uiOutput("input_1") good prediction   
         ),
         
         
        mainPanel(
            tabsetPanel(
                tabPanel("cluster plots" , plotOutput("plots_colored") ),
                tabPanel("clustsummary" , fluidRow(column(4, verbatimTextOutput("clustsummary"))) ),
                tabPanel("scores" ,htmlOutput("scores") )
                ),#tabsetPanel end
            tabsetPanel(
                fluidRow(
                splitLayout(cellWidths = c("50%", "50%"), plotOutput("heatmap1"), plotOutput("heatmap2"))
                ))
                
                

)
)
)
)))
