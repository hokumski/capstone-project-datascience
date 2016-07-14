# Capstone Project | Data Science Specialization | JHSPH Coursera
# ak@dived.me

# Part server.R

suppressWarnings(library(tm))
suppressWarnings(library(stringr))
suppressWarnings(library(shiny))

source('serverFunctions.R')

#load('someUnigrams.RData')  #allUnigrams
load('someBigrams.RData')   #allBigrams
load('someTrigrams.RData')  #allTrigrams
load('someFourgrams.RData') #allFourgrams


shinyServer(
    
    function(input, output) {
        
        dataset <- reactive({
            
            pred<-predictNextWord(input$userQuery, (input$thresholdPercents/100))
            pred
            
        })
        
        output$prediction<-renderPrint({
            
            pred<-dataset()
            
            highlight<-paste('<u>',pred$prediction,'</u>')
            if (pred$prediction=='') {
                highlight<-'<span style="color:#aaa">???</span>'
            }
            
            HTML(paste('<span style="font-size: 150%;">',input$userQuery,highlight,'</span>'))
        })
    
        output$somedebug<-renderPrint({
            
            pred<-dataset()
            
            h<-'<hr/>some debug information<br/>'
            
            HTML(h)
        })
    }
)