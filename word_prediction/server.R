library(shiny)

source("predict_word.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$predWord <- renderPrint({
    try(outputText <- predict_new_word(input$inputText), silent = T)
    
    try(cat(outputText,"\n"),  silent = T)
  })
  
})
