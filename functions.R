
process_data <- function(dataset) {
  
  
  label_col=dataset#$label   #input$select2
  dataset=dataset[,sapply(dataset, class) != "character"]
  dataset=dataset[,sapply(dataset, class) != "factor"]
  dataset_na=na.omit(dataset)
  dataset_num= as.data.frame( apply(dataset_na,2,as.numeric))#asnumeric  kol
  scaled_data=scale(dataset_num)
  return(scaled_data)
    
}


