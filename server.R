#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("functions.R")



# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
        #switching nerbarpage
        observeEvent(input$start, {
        updateNavbarPage(session, "nav", selected = "Data")
        })  
    
        
    
    
    # This reactive function will take the inputs from UI.R and use them for read.table() to read     the data from the file. It returns the dataset in the form of a dataframe.
    # file$datapath -> gives the path of the file
        data <- reactive({
        file1 <- input$file
        if(is.null(file1)){return()} 
        read.table(file=file1$datapath, sep=input$sep, header = input$header, stringsAsFactors =         input$stringAsFactors)
        })

      
        dataset<- reactive({
            
            if(is.null(data())){
                switch( input$select,
               "Iris" = iris,"mtcars" = mtcars,"cars"=cars) }
            else 
                
                data()[,2:length(data())]
            
        })
        
        
        
        output$value1 <- renderPrint({
            str(dataset()[])
        })
       
        
#view dataframe         
        output$view <- renderTable({
        
        head(dataset(), n = 10)
        })
        
#view summary
        output$summary <-renderPrint({
            summary(dataset())
        })
        

#plots df1[, sapply(df1, class) != "character"]       
        output$plots<-renderPlot({
        plot(dataset()[,sapply(dataset(),class) != "character"]) 
            
        })
        
#defining a widget          
        output$input_1 <- renderUI({
            my_list <- as.list(names(dataset())) 
            selectInput("select2", h3("choose the column you want to predict "),
                        choices = my_list   , selected = 1,multiple = FALSE )
        })
            
      
        
#processing Data 

       data_processed<-reactive({
            process_data(dataset())
        
       })
       output$value2 <- renderPrint({
           str(as.data.frame(data_processed()[]))
       })
#submit data 
       
       observeEvent(input$submit, {
           updateNavbarPage(session, "nav", selected = "Analysis")
       }) 
               
       
 
#kmeans 
       #input$R1 
       #kfit=isolate(kmeans(data_processed,input$n))
         
            
            
        
#cluster plots
       kfit<-eventReactive( input$R1 ,{
           kmeans(data_processed(),input$n)
           
       })
       
       
        observeEvent(input$R1, {
        
        output$clustsummary<- renderPrint(str( kfit()) ) 
        output$plots_colored <- renderPlot({pairs(data_processed(),
                        col=kfit()$cluster ) })  
        output$scores <- renderText (paste( tags$h3("between_SS / total_SS ="), kfit()$betweenss/kfit()$totss  ))
        })
        
        
        
        
#heatmap
        newdata<- eventReactive( input$val2 ,{
            as.matrix(data_processed())[order(kfit()$cluster),]
            
        })
        
        observeEvent(input$val2 , {
            output$heatmap1 <-renderPlot({ heatmap((newdata())  ,Rowv = NA ) })
            output$heatmap2 <-renderPlot({ heatmap(t(newdata())  ,Rowv = NA ) })
            
        })

        
        
})

    