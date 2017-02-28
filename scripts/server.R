shinyServer(function(input, output) {
    source("./shinyScript.R")
    QA <- reactive({
        getQAFromURL(input$URL)})
    
    output$question <- renderText(QA()[1])
    output$answers <- renderPrint(QA()[2:length(QA())])
})