# Capstone Project | Data Science Specialization | JHSPH Coursera
# ak@dived.me

# Part ui.R


suppressWarnings(library(shiny))

shinyUI(fluidPage(

    titlePanel("Word Prediction with N-Grams"),
    h2(),
    sidebarLayout(
        
        sidebarPanel(
            textInput('userQuery', 'Say something?',value = ''),
            sliderInput('thresholdPercents', label='Freq.threshold', min = 1, max=100,value = 90)
        ),
        
        mainPanel(
            
            tabsetPanel(type = "pills", 
                        tabPanel("Prediction", 
                                 h2(),
                                 htmlOutput('prediction'),
                                 htmlOutput('somedebug')
                        ), 
                        tabPanel("Readme", 
                                 h4("How it works?"),
                                 a(href="mailto:ak@dived.me","ak@dived.me")
                                 
                        )
            )
            
        )
    )
))