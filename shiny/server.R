# Capstone Project | Data Science Specialization | JHSPH Coursera
# ak@dived.me

# Part server.R

suppressWarnings(library(tm))
suppressWarnings(library(stringr))
suppressWarnings(library(shiny))
suppressWarnings(library(ggplot2))

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
            
            highlight<-paste('<u><b>',pred$prediction,'</b></u>')
            if (pred$prediction=='') {
                highlight<-'<span style="color:#aaa">???</span>'
            }
            
            HTML(paste('<span style="font-size: 150%;">',input$userQuery,highlight,'</span>'))
        })
    
        output$somedebug<-renderPrint({
            
            pred<-dataset()

            h<-'<br/><br/>'
            
            if (nrow(pred$ngram)>0) {
                
                if (pred$depth>0) {
                    h<-paste(h,'Used for prediction: ',pred$depth,'-grams','<br/>',sep='')
                }
            
                h<-paste(h, 'Found phrases starting with this N-gram:',nrow(pred$ngram),'<br/>')
            }
            
            HTML(h)
        })
        
        output$freqplot<-renderPlot({
            
            pred<-dataset()
            
            if (nrow(pred$ngram)>0) {
                
                plotdata <- pred$ngram
                plotdata <- head(plotdata[order(plotdata$freq, decreasing=TRUE), ], 10)
                
                gp<-ggplot(plotdata, aes(terms, freq))+geom_bar(stat='identity')+labs(x='',y='')+theme(axis.text.x = element_text(angle = 90, hjust = 1, size=14))
                
                gp
            }
            
        }, width=400, height=400)
    }
)