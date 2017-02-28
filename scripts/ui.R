library(shiny)
library(shinythemes)

shinyUI(
    navbarPage("Question Answer Scraper",
               theme = shinytheme("simplex"),
               tabPanel("App",
                        span(textOutput("wait")),
                        fluidRow(
                            column(1),
                            column(10,
                                   tags$div(
                                       span(textInput("URL", 
                                                          label = h3("Enter URL here:"),
                                                          width="200%",
                                                          value = )),
                                       tags$style(type="text/css", "#text { height: 50px; width: 100%; font-size: 30px; display: block;}"),
                                       conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                                                        tags$div("Loading...",id="loadmessage")),
                                       tags$style(type="text/css", "#loadmessage { height: 50px; width: 100%; font-size: 30px; display: block;text-align:center;}"),
                                       h4("Question:"),
                                       tags$div(fluidRow(
                                           column(1),
                                           column(10,
                                                  span(style="text-align:center",tags$strong(tags$h3(textOutput("question"))))),
                                           column(1)
                                       )
                                       ),
                                       h4("Answers:"),
                                       tags$div(fluidRow(
                                           column(1),
                                           column(10,
                                                  span(style="text-align:center",verbatimTextOutput("answers"))),
                                           column(1)
                                       )
                                       ),
                                       align="left")
                                   ),
                            column(1)
                            )),
               tabPanel("Help",
                        fluidRow(
                            column(3),
                            column(6,
                                   h2("Question Answer Scraper"),
                                   h4("The goal of this app is to scrap questions and answers form Yahoo Answers and Answers.com."),
                                   hr(),  
                                   h2("How to use the application"),
                                   h4(tags$ol(
                                       tags$li("The user needs to enter URL into text area field."),
                                       tags$li("Question appears at bottom of the text area"),
                                       tags$li("Answers are shown at the bottom")
                                   )),
                                   hr()
                            ),
                            column(3)))
               )
)
